# Example Powershell code snippet for installing a 32bit Oracle client
aws s3 cp s3://ri-enterprise/Oracle/win32_12201_client.zip  ~\Downloads\win32_12201_client.zip 
Expand-Archive -Path win32_12201_client.zip -DestinationPath C:\software
Remove-Item ~\Downloads\win32_12201_client.zip
cd C:\software\client32
aws s3 cp s3://ri-enterprise/Oracle/client.rsp .\client.rsp
.\setup.exe -ignoreSysPrereqs -showProgress -silent -responseFile C:\software\client32\client.rsp
aws s3 cp s3://ri-enterprise/Oracle/tnsnames.ora C:\app\client\product\12.2.0\client_1\network\admin\tnsnames.ora



