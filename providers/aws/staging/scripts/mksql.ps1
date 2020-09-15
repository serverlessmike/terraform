date
echo "+++ Attempting to install SQL Server Management Studio v18..."
choco install sql-server-management-studio

# Get information about this instance

$Region = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).region
$AZ = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).availabilityZone
$InstanceID = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).instanceId

# Initialise AWS CLI

echo "+++ Initialising CLI"
aws configure set region $Region

# Change name of server from the default to "mksql-stg01"

aws ec2 create-tags --resources $InstanceID --tags Key=Name,Value=mksql-stg01
date

