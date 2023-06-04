#!make
include .env
export $(shell sed 's/=.*//' .env)

RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
ENVIRONMENT := $(wordlist 1,1,${RUN_ARGS})
IsSharedEnvironment := false

ifeq (${ENVIRONMENT},shared)
IsSharedEnvironment := true
endif

export TF_VAR_environment_name=$(ENVIRONMENT)
export TF_VAR_namespace=$(CUSTOMER)
export TF_VAR_app_name=$(APP_NAME)

init:
	terraform init \
		-backend-config="bucket=$(TERRAFORM_BACKEND_S3_BUCKET)" \
		-backend-config="key=$(CUSTOMER)-$(APP_NAME).tfstate"\
		-backend-config="region=$(TERRAFORM_BACKEND_S3_REGION)"
plan:
	terraform plan -target=module.$(ENVIRONMENT)_app_setup
deploy:
	terraform apply -auto-approve -target=module.$(ENVIRONMENT)_app_setup
destroy:
	terraform destroy -auto-approve -target=module.$(ENVIRONMENT)_app_setup
terminate:
	terraform destroy -auto-approve