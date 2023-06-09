#!make
include .env
export $(shell sed 's/=.*//' .env)
export TF_VAR_namespace=$(CUSTOMER)

RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
ENVIRONMENT := $(wordlist 1,1,${RUN_ARGS})


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

	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

plan:
	terraform plan \
		-target=module.eks_vpc \
		-target=module.eks_cluster \
		-target=module.k8s_ops_config \
		-target=module.eks_prometheus_grafana \
		-target=module.operational_environment[\"$(ENVIRONMENT)\"]

deploy:
	terraform apply -auto-approve \
		-target=module.eks_vpc \
		-target=module.eks_cluster \

	terraform import module.k8s_ops_config.kubernetes_config_map.aws_auth kube-system/aws-auth || true

	terraform apply -auto-approve \
		-target=module.k8s_ops_config \
		-target=module.eks_prometheus_grafana \
		-target=module.operational_environment[\"$(ENVIRONMENT)\"]
destroy:
	terraform destroy -auto-approve \
		-target=module.operational_environment[\"$(ENVIRONMENT)\"]

terminate:
	terraform destroy -auto-approve