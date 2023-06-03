#!make
include .env
export $(shell sed 's/=.*//' .env)

init:
	aws s3api create-bucket \
		--bucket $(TERRAFORM_BACKEND_S3_BUCKET) \
		--region $(TERRAFORM_BACKEND_S3_REGION) || true; \
	
	terraform init \
		-backend-config="bucket=$(TERRAFORM_BACKEND_S3_BUCKET)" \
		-backend-config="key=$(TERRAFORM_BACKEND_S3_KEY)"\
		-backend-config="region=$(TERRAFORM_BACKEND_S3_REGION)"
plan:
	terraform plan 
deploy:
	terraform apply -auto-approve
destroy:
	terraform destroy -auto-approve