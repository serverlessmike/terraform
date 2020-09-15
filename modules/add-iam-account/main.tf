// Policy variables temporary disabled for hashicorp bug 8621

variable "policy1" {
  default = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

variable "policy2" {
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}

// Operation users

resource "aws_iam_user" "servicedesk" {
  name = "servicedesk"
}

resource "aws_iam_policy_attachment" "servicedesk" {
  name       = "servicedesk"
  users      = ["${aws_iam_user.servicedesk.name}"]
  policy_arn = "${var.policy1}"
}

resource "aws_iam_user" "systeam" {
  name = "systeam"
}

resource "aws_iam_policy_attachment" "systeam" {
  name       = "systeam"
  users      = ["${aws_iam_user.systeam.name}"]
  policy_arn = "${var.policy2}"
}
