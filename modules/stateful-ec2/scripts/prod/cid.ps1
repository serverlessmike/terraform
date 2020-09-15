echo "+++ Attempting to install SQl Server 2017 Developer Edition..."
choco install sql-server-2017
refreshenv

# Get information about this instance

$Region = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).region
$AZ = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).availabilityZone
$InstanceID = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).instanceId

# Initialise AWS CLI

echo "+++ Initialising CLI"
aws configure set region $Region
cd C:\Users\Administrator\Downloads\

# Mount the D drive

echo "+++ Retrieving the latest snapshot of D:"
$DSnap = aws ec2 describe-snapshots --owner self --filter "Name=tag:product,Values=cid" "Name=tag:drive,Values=D" "Name=status,Values=completed" --query 'reverse(sort_by(Snapshots,&StartTime))[0].SnapshotId'
echo "+++ Creating a volume for D:"
$DVolumeId = aws ec2 create-volume --availability-zone $AZ --snapshot-id $DSnap |jq '.VolumeId'
aws ec2 wait volume-available --volume-ids $DVolumeId
echo "+++ Attaching D: volume"
aws ec2 attach-volume --device xvdf --volume-id $DVolumeId --instance-id $InstanceID

# Mount the E drive

echo "+++ Retrieving the latest snapshot of E:"
$ESnap = aws ec2 describe-snapshots --owner self --filter "Name=tag:product,Values=cid" "Name=tag:drive,Values=E" "Name=status,Values=completed" --query 'reverse(sort_by(Snapshots,&StartTime))[0].SnapshotId'
echo "+++ Creating a volume for E:"
$EVolumeId = aws ec2 create-volume --availability-zone $AZ --snapshot-id $ESnap |jq '.VolumeId'
aws ec2 wait volume-available --volume-ids $EVolumeId
echo "+++ Attaching E: volume"
aws ec2 attach-volume --device xvdg --volume-id $EVolumeId --instance-id $InstanceID

# Add tags

aws ec2 create-tags --resources $DVolumeId --tags Key=environment,Value=prod Key=drive,Value=D Key=terraform,Value=1 Key=owner,Value=MOBA Key=repo,Value=cloudops-terraform Key=product,Value=cid Key=Name,Value=cid-D-drive
aws ec2 create-tags --resources $EVolumeId --tags Key=environment,Value=prod Key=drive,Value=E Key=terraform,Value=1 Key=owner,Value=MOBA Key=repo,Value=cloudops-terraform Key=product,Value=cid Key=Name,Value=cid-E-drive
date
