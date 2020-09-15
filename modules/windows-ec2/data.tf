# Data Sources used by the other terraform scripts

data "aws_availability_zones" "available" {
  state = "available"
}

# Get a list of Windows Server 2016 or 2019 AMIs

data "aws_ami" "windows_server" {
  # The next line is a little misleading as the owner is actually 801119661308,
  # but the image owner alias is "amazon".
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-${var.os_version}-English-Full-${var.ami_version}"]
  }
}

# To get a list of possible 2019 versions -
# $ aws ec2 describe-images --owners 'amazon' | awk '/"Name": "Windows_Server-2019-English-Full-/ {print substr($0,55)}'|sort -n

# Get the user data file details

data "template_file" "user_data" {
  template = "${file("${path.module}/userdata.tpl")}"
}

# Get the VPC ID

data "aws_subnet" "mine" {
  id = "${element(split(",",var.private_subnet_ids),0)}"
}
