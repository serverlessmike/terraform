APP_ENV ?=dev

all: test plan apply

plan:
	cd providers/aws/$(APP_ENV) && cp ./config/cd_override.tf ./ && terraform init && terraform plan

apply:
	cd providers/aws/$(APP_ENV) && cp ./config/cd_override.tf ./ && terraform init && terraform apply -auto-approve

.PHONY: test plan apply
