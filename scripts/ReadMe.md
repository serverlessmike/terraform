# CloudOps Scripts

This document describes the use of each script inside this repo.

## Audit AWS Public IPs

This is required for compliance reasons. The information outputted is used to gain accreditations, new and existing.

### Usage

To use this script the following parameters are needed

NOTE - This script reads AWS resources so will need to be run with IAM Authentication (aws-vault most likely)

1. Product Name (**Required**)
2. Environment Name (**Required**)
3. AWS Region (_Optional - Default to `eu-west-1` if empty_)

`./audit_aws_all_public_ips.sh -e <Environment Name> -p <Product Name> -r <Region Name>`

This will output a text file named `<Environment Name>-<Product Name>-public-ips.txt`. This needs to be sent to Mario.Paphitis@river-island.com

### Example

The following example is for CloudOps product in the staging environment.

`./audit_aws_all_public_ips.sh -e staging -p CloudOps -r eu-west-1`
Send mail with attachment `staging-cloudops-public-ips.txt`

## ec2.sh

Connects to an EC2 instance.
This script identifies all appropriate EC2 instances and lets you connect to one of them.
An instance is considered to be appropriate if
 - It is running
 - It is built from a recent Ubuntu or Amazon Linux 2 image
 - It has eic=1 as a tag (so that it can be identified as a host that accepts this type of magic)

Note that you do *not* need the hosts key, as the script uses [magic](https://themagiccircle.co.uk/) to connect.
It does use AWS CLI commands, so ensure that you have AWS credentials loaded before you try it out.

