data "aws_caller_identity" "current" {}

data "archive_file" "lambda_snapshot_backup_zip" {
  type        = "zip"
  source_dir  = "${path.module}/source"
  output_path = "${path.module}/lambda_snapshot_backup.zip"
}

resource "aws_lambda_function" "backup_ami" {
  function_name    = "backup_ami"
  filename         = "${path.module}/lambda_snapshot_backup.zip"
  source_code_hash = "${data.archive_file.lambda_snapshot_backup_zip.output_base64sha256}"
  description      = "Styleman Web and CID AMI daily backup"
  handler          = "lambda-snapshot-backup.lambda_handler"
  memory_size      = "256"
  timeout          = "60"
  role             = "${var.lambda_role}"
  runtime          = "python3.7"

  environment = {
    variables = {
      REGION                = "${var.region}"
      TOPIC_ARN             = "${var.sns_topic_arn}"
      LOG_LEVEL             = "INFO"
      RETENTION_DAYS        = "${var.retention_days}"
      WS_BACKUP_TAG_KEY1    = "${var.ws_backup_tag1_key}"
      WS_BACKUP_TAG_VALUE1  = "${var.ws_backup_tag1_value}"
      WS_BACKUP_TAG_KEY2    = "${var.ws_backup_tag2_key}"
      WS_BACKUP_TAG_VALUE2  = "${var.ws_backup_tag2_value}"
      CID_BACKUP_TAG_KEY1   = "${var.cid_backup_tag1_key}"
      CID_BACKUP_TAG_VALUE1 = "${var.cid_backup_tag1_value}"
      CID_BACKUP_TAG_KEY2   = "${var.cid_backup_tag2_key}"
      CID_BACKUP_TAG_VALUE2 = "${var.cid_backup_tag2_value}"
    }
  }
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.backup_ami.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${var.sns_topic_arn}"
}

resource "aws_cloudwatch_event_rule" "backup_ami_schedule" {
  name                = "backup_ami_schedule"
  description         = "Periodically invokes backup_ami"
  schedule_expression = "cron(0 2 * * ? *)"
  is_enabled          = true
  depends_on          = ["aws_lambda_function.backup_ami"]
}

resource "aws_cloudwatch_event_target" "backup_ami" {
  rule = "${aws_cloudwatch_event_rule.backup_ami_schedule.name}"
  arn  = "${aws_lambda_function.backup_ami.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_backup_ami" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.backup_ami.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.backup_ami_schedule.arn}"
}
