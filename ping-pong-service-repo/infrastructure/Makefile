#!make
include .env
export $(shell sed 's/=.*//' .env)

RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
ENVIRONMENT := $(wordlist 1,1,${RUN_ARGS})

export TF_VAR_environment_name=$(ENVIRONMENT)
export TF_VAR_namespace=$(CUSTOMER)
export TF_VAR_app_name=$(APP_NAME)

init:
	terraform init \
		-backend-config="bucket=$(TERRAFORM_BACKEND_S3_BUCKET)" \
		-backend-config="key=$(CUSTOMER)-$(APP_NAME).tfstate"\
		-backend-config="region=$(TERRAFORM_BACKEND_S3_REGION)"

# Environments management
plan-env:
	terraform plan -target=module.environment_app_setup[\"$(ENVIRONMENT)\"]
deploy-env:
	terraform apply -auto-approve -target=module.environment_app_setup[\"$(ENVIRONMENT)\"]
destroy-env:
	terraform destroy -auto-approve -target=module.environment_app_setup[\"$(ENVIRONMENT)\"]

# Pipeline management
plan-pipeline:
	terraform plan -target=module.pipeline_setup
deploy-pipeline:
	terraform apply -auto-approve -target=module.pipeline_setup
destroy-pipeline:
	terraform destroy -auto-approve -target=module.pipeline_setup

# Destroy all resources
terminate:
	terraform destroy -auto-approve