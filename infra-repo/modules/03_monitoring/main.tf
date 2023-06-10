terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.0"
    }
  }
}