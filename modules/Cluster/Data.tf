locals {
  gitlab-role = "gitlab-runner-service-account-role"
  gitlab-sa = "gitlab-runner-sa"
  env = "prod"
  gitlab-ns = "gitlab-runner"
}

data "aws_caller_identity" "current" {}


data "aws_eks_cluster" "eks" {
  name = var.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
  depends_on = [module.eks]
}