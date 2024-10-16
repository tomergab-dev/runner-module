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

variable "aws_profile" {
  description = "The aws profile"
  type        = string
  default = "default"
}

variable "desired_nodes" {
  description = "The desired nodes number"
  type        = string
  default = "1"
}

variable "min_nodes" {
  description = "The minimum nodes number"
  type        = string
  default = "1"
}

variable "max_nodes" {
  description = "The max nodes number"
  type        = string
  default = "5"
}