set_pipeline:
	fly -t cloudops set-pipeline -c main.yml -p cloudops-terraform
	fly -t cloudops expose-pipeline --pipeline cloudops-terraform
	fly -t cloudops set-pipeline -c prs.yml -p cloudops-terraform-prs
	fly -t cloudops expose-pipeline --pipeline cloudops-terraform-prs

default: set_pipeline ;
