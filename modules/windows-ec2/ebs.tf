locals {
  volume_sizes  = ["${compact(list(var.d_volume,var.e_volume,var.f_volume))}"]
  drive_letters = ["D", "E", "F"]
}

resource "aws_ebs_volume" "win_drives" {
  count             = "${length(local.volume_sizes)}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  size = "${element(local.volume_sizes,count.index)}"

  tags = {
    environment = "${var.environment}"
    drive       = "${element(local.drive_letters,count.index)}"
    terraform   = true
    product     = "${var.product}"
    owner       = "${var.owner}"
    repo        = "cloudops-terraform"
    Name        = "${var.product}-${element(local.drive_letters,count.index)}-drive"
  }
}
