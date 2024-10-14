variable "cluster_name" {
  type = string
  description = "Cluster display name"
  default = "gitlab-runner-cluster"
}

variable "instance_type" {
  type = string
  description = "Node group instance type"
  default = "m5.large"
}


variable "runner_token" {
  description = "The GitLab Runner token"
  type        = string
}

variable "region" {
  description = "The aws region"
  type        = string
  default = "us-west-2"
}