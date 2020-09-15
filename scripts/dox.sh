#!/bin/bash

# Run this is a directory which contains a new tf module
# and it will run terraform ftm against your tf files,
# and then create a skeletopn Readme.md file for you,
# then drop you into an edit of that file

# Simple die function, every command should be followed by this!
die() { >&2 echo `basename $0`: $* ; exit 1 ; }

ls *.tf >/dev/null 2>&1 || die 'Is this even a freakin tf module?'
ls var*.tf >/dev/null 2>&1 || die 'Please put the input variables into a file named variables.tf'

CWD=`PWD` || die 'I am lost, no CWD'
MODULE=`basename $CWD` || die 'I am lost, no CWD'

# This section runs terraform fmt against the appropriate files

echo -n "Formatting tf files..."
hash terraform || die "No terraform in PATH"
echo

ls -1 *.tf | while read TF_FILE
do
   echo -n "Running fmt on ${TF_FILE}..."
   terraform fmt $TF_FILE >/dev/null
   echo done
done

# Quit if Readme already exists

[ -f Readme.md ] && die 'Readme.md already exists. If you want to keep it, then rename it and re-run dox'

# Create a skeleton Readme file

echo -n "Creating Readme.md ..."
(echo \# $MODULE Module ; echo ; echo '{add explanation here}' ; echo) > Readme.md

# Extract the input variables into a table in the Readme file in markdown format

awk 'BEGIN			{printf("## Inputs\n\n| Name | Description | Type | Default | Required |\n|------|-------------|------|-------|-------|\n")}
	{gsub(/"/,"")}
	$1=="variable"		{NAME=$2;REQUIRED="yes";TYPE="string";DESCRIPTION="none";DEFAULT="-"}
	$1=="type" 		{TYPE=$3}
	$1=="description"	{DESCRIPTION=substr($0,17)}
	$1=="default"		{DEFAULT=$3;REQUIRED="no"}
	$1=="}"			{printf("| %s | %s | %s | %s | %s |\n",NAME,DESCRIPTION,TYPE,DEFAULT,REQUIRED)}' var*.tf >>Readme.md


# Extract the output variables into a table in the Readme file in markdown format

awk 'BEGIN			{printf("\n## Outputs\n\n| Name | Description |\n|------|-------------|\n")}
	{gsub(/"/,"")}
	$1=="output"		{NAME=$2;DESCRIPTION="none"}
	$1=="description"	{DESCRIPTION=substr($0,17)}
	$1=="default"		{DEFAULT=$3}
	$1=="}"			{printf("| %s | %s |\n",NAME,DESCRIPTION)}' out*.tf 2>/dev/null >>Readme.md

echo done

vi +3 Readme.md
exit 0

