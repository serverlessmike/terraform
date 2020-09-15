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
echo "*** Attempting to install Filezilla..."
choco install filezilla
echo "*** Attempting to install Git..."
choco install git
echo "*** Attempting to install jq..."
choco install jq
echo "*** Adding AWS CLI to Path..."
$env:Path += ";C:\Program Files\Amazon\AWSCLI\bin"
echo "*** Disable Windows Defender..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
date
echo "*** Standard server installation complete"

echo "+++ Attempting to retrieve customisation script"
$Region = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).region
aws configure set region $Region
$InstanceID = (Invoke-RestMethod -uri http://169.254.169.254/latest/dynamic/instance-identity/document).instanceId
$Environment = aws ec2 describe-tags --filters "Name=resource-id,Values=$InstanceID"|jq -r '.Tags[]|select(.Key==\"environment\").Value'
$CustomisationScript = aws ec2 describe-tags --filters "Name=resource-id,Values=$InstanceID"|jq -r '.Tags[]|select(.Key==\"custom\").Value'
aws s3 cp "s3://ri-enterprise/$Environment/$CustomisationScript" C:\Users\Administrator\Downloads\custom.ps1

echo "+++ Invoking customisation script"
.("C:\Users\Administrator\Downloads\custom.ps1")

</powershell>
