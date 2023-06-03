# EKS Infrastructure Challenge

## Overview
The approach of this design is to separate the centralized infrastructure components from the application components. This allows for the infrastructure to be managed by a centralized team and the application components to be managed by the application teams.

To do so, the centralized infrastructure components are managed through IAC in `infra-repo` directory which should be a separate repository, and the application components are managed through IAC in `ping-pong-service-repo` directory which should be a separate repository.

This design allows us to add more applications by adding more application repositories without having to change the infrastructure repository.

## Assumptions
The following assumptions were made:
- The infrastructure repository is managed by a centralized team.
- The application repository is managed by an application team.
- Only 1 AWS account is used.
- Only 1 EKS cluster is used.
- 2 environments are available: `dev` and `prod`.
- Environments isolation would be achieved using K8S namespaces.
- Github actions are used for CI/CD.