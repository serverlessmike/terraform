# Example Powershell code snippet for installing a 64bit Oracle client
aws s3 cp s3://ri-enterprise/Oracle/winx64_12201_client.zip  ~\Downloads\win32_12201_client.zip 
Expand-Archive -Path winx64_12201_client.zip -DestinationPath C:\software
Remove-Item ~\Downloads\winx64_12201_client.zip
cd C:\software\clientx64
aws s3 cp s3://ri-enterprise/Oracle/client.rsp .\client.rsp
.\setup.exe -ignoreSysPrereqs -showProgress -silent -responseFile C:\software\clientx64\client.rsp
aws s3 cp s3://ri-enterprise/Oracle/tnsnames.ora C:\app\client\product\12.2.0\client_1\network\admin\tnsnames.ora



