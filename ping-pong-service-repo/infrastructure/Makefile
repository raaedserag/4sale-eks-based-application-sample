#!make
include .env
export $(shell sed 's/=.*//' .env)
export TF_VAR_namespace=$(CUSTOMER)
export TF_VAR_app_name=$(APP_NAME)

init:
	terraform init \
		-backend-config="bucket=$(TERRAFORM_BACKEND_S3_BUCKET)" \
		-backend-config="key=$(CUSTOMER)-$(APP_NAME).tfstate"\
		-backend-config="region=$(TERRAFORM_BACKEND_S3_REGION)"
plan:
	terraform plan 
deploy:
	terraform apply -auto-approve
destroy:
	terraform destroy -auto-approve