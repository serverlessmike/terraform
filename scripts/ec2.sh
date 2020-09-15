#!/bin/bash


# ec2.sh by mikec
# Connects to an EC2 instance
#
# In order to get this to work with a new server, please ensure that the server is reachable
# from your laptop and that it has "eic=1" as a tag.
#
# Client pre-requisites; jq, SSH and AWS CLI
# Server pre-requisites; Amazon Linux 2 or Ubunto 16.04+
#
# If this doesn't work for your Ubuntu server, then update the server with:
#    sudo apt-get update ; sudo apt-get install ec2-instance-connect


# Simple die function, every command should be followed by this!
die() { >&2 echo `basename $0`: $* ; exit 1 ; }

# Simple function to print a dot, to show that we are still alive and to aid debugging
dot() { echo -n \. ; }

# check PATH
hash jq  2>/dev/null || die "jq not found in PATH"
hash aws 2>/dev/null || die "AWS CLI not found in PATH"
hash ssh 2>/dev/null || die "SSH not found in PATH"

# Check CLI version
aws ec2-instance-connect send-ssh-public-key help >/dev/null 2>&1 || die "You need to update your AWS CLI"

# Check that we're on a mac
[[ "$OSTYPE" == "darwin"* ]] || die "macOS only, soz"

# check creds
dot
aws s3 ls >/dev/null 2>&1 || die "No AWS credentials found"

# get eic instances
dot
INSTANCE_ID=`aws ec2 describe-instances --filters "Name=tag:eic,Values=1" --query 'Reservations[*].Instances[*].[InstanceId]'|jq -r '.[][][]'`
[ -z "$INSTANCE_ID" ] && die "no hosts found"

# If necessary, then get user to pick one or default to the first found
set $INSTANCE_ID
if [ $# -gt 1 ]
then
	select INSTANCE ;  do 
	      break ;  done
	INSTANCE_ID=$INSTANCE
	[ -z "$INSTANCE_ID" ] && INSTANCE_ID=$1
fi

# Get Instance info
dot
aws ec2 describe-instances --instance-ids $INSTANCE_ID > /tmp/$INSTANCE_ID
ZONE=`jq -r '.Reservations[].Instances[].Placement.AvailabilityZone' /tmp/$INSTANCE_ID`
PUBLIC_ADDR=`jq -r '.Reservations[].Instances[].NetworkInterfaces[].Association.PublicDnsName' /tmp/$INSTANCE_ID`
NAME=`jq -r '.Reservations[].Instances[].Tags|from_entries|.Name' /tmp/$INSTANCE_ID`
IMAGE_ID=`jq -r '.Reservations[].Instances[].ImageId' /tmp/$INSTANCE_ID`

# Quit if the instance is not running
[ `jq -r '.Reservations[].Instances[].State.Name' /tmp/$INSTANCE_ID` = "running" ] || die "Instance is not running!"

# Get OS type and version
dot
case "`aws ec2 describe-images --image-ids $IMAGE_ID | jq -r '.Images[].Description'`" in
	Canonical,\ Ubuntu*) USER_NAME="ubuntu" ;;
	Amazon\ Linux\ 2*)   USER_NAME="ec2-user" ;;
	*) die "EIC does not work for this OS" ;;
esac

# Remove old known_hosts
cd ~/.ssh
rm -f ./known_hosts

# Remove old keys and generate new
rm -f /tmp/$INSTANCE_ID ${INSTANCE_ID}.pub $INSTANCE_ID
dot
ssh-keygen -t rsa -f $INSTANCE_ID -N '' >/dev/null || die "Failed to generate key"
dot
#ssh-keyscan -t ecdsa-sha2-nistp256 $PUBLIC_ADDR >> ~/.ssh/known_hosts

# send key to instance
dot
aws ec2-instance-connect send-ssh-public-key --region eu-west-1 --instance-id $INSTANCE_ID --availability-zone $ZONE --instance-os-user $USER_NAME --ssh-public-key file://${INSTANCE_ID}.pub > /tmp/eic_info.json || die "Failed to send key to instance $INSTANCE_ID"

# SSH
dot
echo Starting session on $NAME as $USER_NAME
ssh -i $INSTANCE_ID ${USER_NAME}@$PUBLIC_ADDR

# Clean up
rm -f /tmp/$INSTANCE_ID ${INSTANCE_ID}.pub $INSTANCE_ID

