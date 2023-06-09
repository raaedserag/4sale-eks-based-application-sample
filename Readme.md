# 4Sale EKS Infrastructure Challenge

## Overview
The approach of this design is to separate the centralized infrastructure components from the application components. This allows for the infrastructure to be managed by a centralized infra team and the application components to be managed by the application teams.

To do so, the centralized infrastructure components are managed through IAC in `infra-repo` directory which should be a separate repository, and the application components are managed through IAC in `ping-pong-service-repo` directory which should be a separate repository.

This design allows us to add more applications by adding more application repositories without having to change the centralized infrastructure repository.

## Assumptions
The following assumptions were made:
- The infrastructure repository is managed by a centralized team.
- The application repository can be managed by a separate application team.
- Only 1 AWS account is used.
- Only 1 EKS cluster is used.
- Mainly supporting 2 operational environments: `staging` and `production`.
- Adding more environments is possible with zero changes to the infrastructure code, just inject the environment name as a variable.
- Environments isolation would be achieved using K8S namespaces.
- AWS Developer Tools are used for CI/CD.
- Helm is used for K8S package management.
- Terraform is used for IAC.
- Each application has its own pipeline structure which is defined in the application repository.


## [Infrastructure Repository](./infra-repo)
## [Application Repository](./ping-pong-service-repo)