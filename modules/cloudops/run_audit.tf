// Audit AWS infrastructure nightly, dumping the results as objects into a bucket

module "run_nightly_audit" {
  source = "git::ssh://git@github.com/river-island/shared-lambdas.git//terraform/modules/lambda_audit_aws?ref=c385545abc18c96e03680cc82ae7b0e20a4ada03"
}
