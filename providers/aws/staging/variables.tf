variable "zone_id" {
  default = "Z2JQU8EVU3KVBR"
}

variable "retention_days" {
  default = 60
}

variable "environment" {
  default = "staging"
}

variable "project_name" {
  default = "styleman"
}

variable "project_name_cid" {
  default = "cid"
}

variable "project_name_uc4" {
  default = "uc4"
}

// EC2 //

variable "ami_id" {
  default = "ami-0cf80031683a84076"
}

variable "ami_id_cid" {
  default = "ami-0cf80031683a84076"
}

variable "ami_id_uc4" {
  default = "ami-0b341cefa14ccca70"
}

variable "ec2size" {
  default = "m4.xlarge"
}

variable "intip" {
  default = "10.202.96.5"
}

variable "pubkey" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAlZM7lgVUiOlsZbbeB2JRGrFNnZsbLGAdCk0scj3VY8kxf1ch2HUXlVNQbW8sG8Yw57inJMBKEXzKoJ0y3zvulUZmB+SLuWbzQrEw/k2iMCzuxxBBiMgxm7QvxW1ULvx00xwv15U/7uRinL2dum19ccwz2BMrNNk/arNjIzNfZu1Uo+MRhJfDorkbwM/ohAYXsUFqCgdArWAfJppQwfkkunQ81cvATGD557jnCjbhhegx6Xm92tWpQuz+b2KkyOgS1vSF39Kj5ulnpG0qRZDkU/xtOdGhr0Kbssfj2cRtAhTUhAj1UYtcI3Dsqx5LnXYBqVdue0mn4qDesqsTG4TeKw== terraform@rlansible"
}

// monitoring

variable "sns_encrypted_slack_webhook_url" {
  description = "Encrypted slack webhook url"
  default     = "AQICAHgmjMRhXDrD2MVLexJFi1xhi1QO7B6RADBhTkcB3wPtAAEYCnDzZ2A/V+18Lym9f7w6AAAApzCBpAYJKoZIhvcNAQcGoIGWMIGTAgEAMIGNBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDGbPdV7ihtae2/EMFgIBEIBgwEYiosTJ2+xLW5LiakY4GU/K+appY/OrShv/8zPTq0o2IDNiukcV0Gw8UT9wC+xO2X+mE4QQgyTDKG28j2OMFPoFQNj09uKfg3TbJhsUhvZsZEQNQ9m8KPSZ3Pln5CTc"
}
