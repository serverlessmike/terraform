# Add new volume(s) and attach to a named instance

resource "aws_ebs_volume" "new_volumes" {
  count             = "${length(var.drives)}"
  availability_zone = "${data.aws_instance.mine.availability_zone}"
  size              = "${element(var.volume_sizes,count.index)}"

  tags = {
    Name        = "${var.product}-${element(var.drives,count.index)}-drive"
    drive       = "${element(var.drives,count.index)}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    product     = "${var.product}"
    terraform   = "true"
    repo        = "cloudops-terraform"
  }
}

resource "aws_volume_attachment" "temp_att" {
  count       = "${length(var.drives)}"
  device_name = "${element(var.devices,count.index)}"
  volume_id   = "${element(aws_ebs_volume.new_volumes.*.id,count.index)}"
  instance_id = "${var.instance_id}"
}
