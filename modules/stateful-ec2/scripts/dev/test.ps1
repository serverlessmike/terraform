date
echo "+++ Attempting to install SQl Server 2017 Developer Edition..."
choco install sql-server-2017
refreshenv
echo "+++ Attempting to install SQL Server Management Studio v18..."
choco install sql-server-management-studio
echo "+++ Attempting to install Oracle SQL Developer..."
# Use dummy username and password as placeholders
choco install oracle-sql-developer --params "'/Username:mike.charles@oracle.com /Password:FZ?scsezi6,XgG&'"
date
