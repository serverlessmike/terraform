// CW Events
module "cwevents" {
  source = "../cwevents"

  wmselbname = "${var.wms_elb_name}"
}

// Instance Profiles
module "profiles" {
  source = "../profiles"
}

resource "aws_kms_key" "styleman" {}

resource "aws_kms_alias" "styleman" {
  name          = "alias/styleman"
  target_key_id = "${aws_kms_key.styleman.key_id}"
}
