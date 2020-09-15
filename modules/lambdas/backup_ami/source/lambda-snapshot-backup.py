import boto3
import collections
import datetime
import base64
import os
import json
import itertools
import logging
import re

from datetime import date

# logging.basicConfig(level=os.environ.get('LOG_LEVEL', 'INFO'))
# logger = logging.getLogger(__name__)
logger = logging.getLogger()
logger.setLevel(logging.INFO)
log_handler = logging.StreamHandler()
log_handler.setLevel(logging.INFO)
log_formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
log_handler.setFormatter(log_formatter)
logger.addHandler(log_handler)

# get env variables passed in from terraform
region = os.getenv('REGION', 'eu-west-1')
wsTagKey1 = os.getenv('WS_BACKUP_TAG_KEY1', 'Name')
wsTagValue1 = os.getenv('WS_BACKUP_TAG_VALUE1', 'styleman-staging')
wsTagKey2 = os.getenv('WS_BACKUP_TAG_KEY2', 'backup')
wsTagValue2 = os.getenv('WS_BACKUP_TAG_VALUE2', 'True')

cidTagKey1 = os.getenv('CID_BACKUP_TAG_KEY1', 'Name')
cidTagValue1 = os.getenv('CID_BACKUP_TAG_VALUE1', 'cid-staging')
cidTagKey2 = os.getenv('CID_BACKUP_TAG_KEY2', 'backup')
cidTagValue2 = os.getenv('CID_BACKUP_TAG_VALUE2', 'True')
awsSnsArn = os.getenv('TOPIC_ARN')
retentionDays = os.getenv('RETENTION_DAYS', '60')

def lambda_handler(event, context):


    tidy_up_snapshots(wsTagKey1, wsTagValue1, wsTagKey2, wsTagValue2)
    tidy_up_snapshots(cidTagKey2, cidTagValue1, cidTagKey2, cidTagValue2)

    backup_snapshot(wsTagKey1, wsTagValue1, wsTagKey2, wsTagValue2)
    backup_snapshot(cidTagKey1, cidTagValue1, cidTagKey2, cidTagValue2)


def backup_snapshot(searchTagKey1, searchTagValue1, searchTagKey2, searchTagValue2):


    logger.info("backup_snapshots: searchTagKey1: {0}, searchTagValue1: {1}, searchTagKey2: {2}, searchTagValue2: {3}".format(searchTagKey1, searchTagValue1, searchTagKey2, searchTagValue2))
    ec = boto3.client('ec2', region_name=region)

    reservations = ec.describe_instances(
            Filters=[
                {'Name':'tag:' + searchTagKey1, 'Values':[searchTagValue1 + '*']},
                {'Name':'tag:' + searchTagKey2, 'Values':[searchTagValue2]},
            ]
        ).get(
            'Reservations', []
        )

    logger.info("Reservation: {0}".format(reservations))
    instances = sum(
        [
            [i for i in r['Instances']]
            for r in reservations
        ], [])

    logger.info("Found {0} possible instances candidates for backup...".format(len(instances)))

    to_tag_retention = collections.defaultdict(list)
    to_tag_mount_point = collections.defaultdict(list)

    for instance in instances:
        try:
            retention_days = [
                int(t.get('Value')) for t in instance['Tags']
                if t['Key'] == 'retention'][0]
        except IndexError:
                retention_days = retentionDays

        try:
            skip_volumes = [
                str(t.get('Value')).split(',') for t in instance['Tags']
                if t['Key'] == 'Skip_Backup_Volumes']
        except Exception:
            pass

        logger.info("retention days {0}...".format(retention_days))

        from itertools import chain
        skip_volumes_list = list(chain.from_iterable(skip_volumes))

        for dev in instance['BlockDeviceMappings']:
            if dev.get('Ebs', None) is None:
                continue

            vol_id = dev['Ebs']['VolumeId']
            if vol_id in skip_volumes_list:
                logger.info("Volume {0} is set to be skipped, not backing up".format(vol_id))
                continue

            dev_attachment = dev['DeviceName']

            logger.info("Found EBS volume {0} on instance {1} attached to {2}".format(
                vol_id, instance['InstanceId'], dev_attachment))

            instance_name = ''
            try:
                instance_name = [ x['Value'] for x in instance['Tags'] if x['Key'] == 'Name' ][0]
            except IndexError:
                pass

            try:
                logger.info("creating snapshot EBS volume {0}...".format(vol_id))

                snap = ec.create_snapshot(
                    VolumeId=vol_id,
                    Description='backup volume {0}'.format(vol_id)
                )
            except:
                try:
                    # logger.info("Sending RDS SNS")
                    message = "Error creating snapshot for volume: {0}".format(vol_id)
                    send_to_sns('EBS Backups Error', message, awsSnsArn)
                except:
                    pass


            to_tag_retention[retention_days].append(snap['SnapshotId'])
            to_tag_mount_point[vol_id].append(snap['SnapshotId'])

            logger.info("Retaining snapshot {0} of volume {1} from instance {2} for {3} days".format(
                snap['SnapshotId'],
                vol_id,
                instance['InstanceId'],
                retention_days,
            ))

            ec.create_tags(
                Resources=to_tag_mount_point[vol_id],
                Tags=[
                    {'Key': searchTagKey1, 'Value': searchTagValue1},
                    {'Key': searchTagKey2, 'Value': searchTagValue2},
                ]
            )

    for retention_days in to_tag_retention.keys():
        delete_date = datetime.date.today() + datetime.timedelta(days=int(retention_days))
        delete_fmt = delete_date.strftime('%Y-%m-%d')
        logger.info("Will delete {0} snapshots on {1}".format(len(to_tag_retention[retention_days]), delete_fmt))

        ec.create_tags(
            Resources=to_tag_retention[retention_days],
            Tags=[
                {'Key': 'DeleteOn', 'Value': delete_fmt},
            ]
        )



def tidy_up_snapshots(searchTagKey1, searchTagValue1, searchTagKey2, searchTagValue2):

    logger.info("Cleaning up snapshots in region: {0}".format(region))

    ec = boto3.client('ec2', region_name=region)
    iam = boto3.client('iam')

    account_ids = list()
    try:
        # iam.get_user()
        account_ids.append(boto3.client('sts').get_caller_identity().get('Account'))
    except Exception as e:
        # use the exception message to get the account ID the function executes under
        account_ids.append(re.search(r'(arn:aws:sts::)([0-9]+)', str(e)).groups()[1])


    delete_on = datetime.date.today().strftime('%Y-%m-%d')
    filters=[
        {'Name':'tag:' + searchTagKey1, 'Values':[searchTagValue1 + '*']},
        {'Name':'tag:' + searchTagKey2, 'Values':[searchTagValue2]},
        {'Name': 'tag-value', 'Values': [delete_on]},
    ]
    snapshot_response = ec.describe_snapshots(OwnerIds=account_ids, Filters=filters)
    # snapshot_response = ec.describe_snapshots(OwnerIds=account_ids)

    logger.info("Found {0} snapshots that need deleting in on {1}".format(
        len(snapshot_response['Snapshots']),
        delete_on))

    for snap in snapshot_response['Snapshots']:
        logger.info("Deleting snapshot {0}".format(snap['SnapshotId']))
        ec.delete_snapshot(SnapshotId=snap['SnapshotId'])

    # message = "{0} snapshots have been cleaned up in".format(len(snapshot_response['Snapshots']))
    # send_to_sns('EBS Backups Cleanup', message, awsSnsArn)





def send_to_sns(subject, message, aws_sns_arn):

    if aws_sns_arn is None or isBlank(aws_sns_arn):
        logger.info("Sending notification require SNS configured!!!")
        return

    logger.info("Sending notification subject: {0}, message {1}".format(subject, message))
    client = boto3.client('sns')

    response = client.publish(
        TargetArn=aws_sns_arn,
        Message=message,
        Subject=subject)

    if 'MessageId' in response:
        logger.info("Notification sent with message id: {0}".format(response['MessageId']))
    else:
        logger.info("Sending notification failed with response: {0}".format(str(response)))

def isBlank (s):
    if s and s.strip():
        # s is not None AND s is not empty or blank
        return False
    # s is None OR s is empty or blank
    return True


# Turn on to test locally
if __name__ == '__main__':
    lambda_handler(None, None)
