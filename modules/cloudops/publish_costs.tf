// Publish AWS costs to CloudWatch
module "publish_costs_to_cw" {
  source = "git::ssh://git@github.com/river-island/shared-lambdas.git//terraform/modules/lambda_publish_aws_costs_to_cw?ref=ee54d9b97a80e8e65b2d25b8b1fc99005e7fe401"
}
