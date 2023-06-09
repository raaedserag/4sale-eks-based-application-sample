#!make
include .env
export $(shell sed 's/=.*//' .env)
export TF_VAR_namespace=$(CUSTOMER)

init:
	aws s3api create-bucket \
		--bucket $(TERRAFORM_BACKEND_S3_BUCKET) \
		--region $(TERRAFORM_BACKEND_S3_REGION) || true;
	aws s3api put-bucket-encryption \
		--bucket $(TERRAFORM_BACKEND_S3_BUCKET) \
		--server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' || true;
	
	terraform init -upgrade\
		-backend-config="bucket=$(TERRAFORM_BACKEND_S3_BUCKET)" \
		-backend-config="key=$(CUSTOMER)-iac.tfstate"\
		-backend-config="region=$(TERRAFORM_BACKEND_S3_REGION)"
plan:
	terraform plan 
deploy:
	terraform apply -auto-approve -target=module.eks_vpc
	terraform apply -auto-approve -target=module.eks_cluster
	terraform import module.k8s_config.kubernetes_config_map.aws_auth kube-system/aws-auth || true
	terraform apply -auto-approve -target=module.k8s_config
	terraform apply -auto-approve -target=module.staging_environment
	terraform apply -auto-approve -target=module.production_environment
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	terraform apply -auto-approve -target=module.eks_grafana_prometheus
destroy:
	terraform destroy -auto-approve