# Data Sources used by the other terraform scripts

data "aws_availability_zones" "available" {
  state = "available"
}

# Get a list of Windows Server 2019 AMIs

data "aws_ami" "win2019" {
  # The next line is a little misleading as the owner is actually 801119661308,
  # but the image owner alias is "amazon".
  count = "${length(var.ami_versions)}"

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-${element(var.ami_versions,count.index)}"]
  }
}

# To get a list of possible versions -
# $ aws ec2 describe-images --owners 'amazon' | awk '/"Name": "Windows_Server-2019-English-Full-Base/ {print substr($0,60,10)}'|sort -n

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.tpl")}"
}

# Get the VPC ID
data "aws_subnet" "selected" {
  id = "${element(split(",",var.private_subnet_ids),0)}"
}
