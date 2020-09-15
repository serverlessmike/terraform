<powershell>
date
echo "*** Attempting to install Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation
echo "*** Attempting to install Python..."
choco install python
echo "*** Attempting to install Terraform..."
choco install terraform
echo "*** Attempting to install AWS CLI..."
choco install awscli
echo "*** Skipping Filezilla as it takes too long to download from an external site"
#choco install filezilla
echo "*** Attempting to install Git..."
choco install git
echo "*** Attempting to install jq..."
choco install jq
echo "*** Adding AWS CLI to Path..."
$env:Path += ";C:\Program Files\Amazon\AWSCLI\bin"
echo "*** Disable Windows Defender..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
echo "*** Configure AWS CLI..."
aws configure set region (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).region
$AZ = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).availabilityZone
$InstanceID = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).instanceId
$Environment = aws ec2 describe-tags --filters "Name=resource-id,Values=$InstanceID"|jq -r '.Tags[]|select(.Key==\"environment\").Value'
$Product= aws ec2 describe-tags --filters "Name=resource-id,Values=$InstanceID"|jq -r '.Tags[]|select(.Key==\"product\").Value'

# Mount the D drive from a backup (if a successful one exists), otherwise from an EBS volume

$DSnap = aws ec2 describe-snapshots --owner self --filter "Name=tag:product,Values=$Product" "Name=tag:drive,Values=D" "Name=status,Values=completed" --query 'reverse(sort_by(Snapshots,&StartTime))[0].SnapshotId' 
$DVolumeId = if ($DSnap.StartsWith("snap-")) { aws ec2 create-volume --availability-zone $AZ --snapshot-id $DSnap |jq '.VolumeId' } else { aws ec2 describe-volumes --filters Name=tag:product,Values=$Product Name=tag:drive,Values=D | jq '.Volumes[].VolumeId' }
aws ec2 wait volume-available --volume-ids $DVolumeId
echo "*** Attaching D: volume"
aws ec2 attach-volume --device xvdf --volume-id $DVolumeId --instance-id $InstanceID

# Mount the E drive from a backup (if a successful one exists), otherwise from an EBS volume

$ESnap = aws ec2 describe-snapshots --owner self --filter "Name=tag:product,Values=$Product" "Name=tag:drive,Values=E" "Name=status,Values=completed" --query 'reverse(sort_by(Snapshots,&StartTime))[0].SnapshotId' 
$EVolumeId = if ($ESnap.StartsWith("snap-")) { aws ec2 create-volume --availability-zone $AZ --snapshot-id $ESnap |jq '.VolumeId' } else { aws ec2 describe-volumes --filters Name=tag:product,Values=$Product Name=tag:drive,Values=E | jq '.Volumes[].VolumeId' }
aws ec2 wait volume-available --volume-ids $EVolumeId
echo "*** Attaching E: volume"
aws ec2 attach-volume --device xvdg --volume-id $EVolumeId --instance-id $InstanceID

# Mount the F drive from a backup (if a successful one exists), otherwise from an EBS volume

$FSnap = aws ec2 describe-snapshots --owner self --filter "Name=tag:product,Values=$Product" "Name=tag:drive,Values=F" "Name=status,Values=completed" --query 'reverse(sort_by(Snapshots,&StartTime))[0].SnapshotId' 
$FVolumeId = if ($FSnap.StartsWith("snap-")) { aws ec2 create-volume --availability-zone $AZ --snapshot-id $FSnap |jq '.VolumeId' } else { aws ec2 describe-volumes --filters Name=tag:product,Values=$Product Name=tag:drive,Values=F | jq '.Volumes[].VolumeId' }
aws ec2 wait volume-available --volume-ids $FVolumeId
echo "*** Attaching F: volume"
aws ec2 attach-volume --device xvdh --volume-id $FVolumeId --instance-id $InstanceID
date
echo "*** Standard server installation complete"

echo "+++ Retrieving customisation script"
$CustomisationScript = aws ec2 describe-tags --filters "Name=resource-id,Values=$InstanceID"|jq -r '.Tags[]|select(.Key==\"custom\").Value'
aws s3 cp "s3://ri-enterprise/$Environment/$CustomisationScript" C:\Users\Administrator\Downloads\custom.ps1
echo "+++ Invoking customisation script"
.("C:\Users\Administrator\Downloads\custom.ps1")

</powershell>
