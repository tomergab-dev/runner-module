variable "cluster_name" {
  type = string
  description = "Cluster display name"
}

variable "instance_type" {
  type = string
  description = "Node group instance type"
  default = "t3.medium"
}

variable "vpc_id" {
  type = string
  description = "Id of main vpc"
}

variable "private_subnet1" {
  type = string
  description = "Id of subnet1 private"
}

variable "private_subnet2" {
  type = string
  description = "Id of subnet2 private"
}

variable "min_nodes" {
  type = number
  description = "Nodegroup min nodes number"
}

variable "max_nodes" {
  type = number
  description = "Nodegroup max nodes number"
}

variable "desired_nodes" {
  type = number
  description = "Nodegroup desired nodes number"
}

variable "runner_token" {
  description = "The GitLab Runner token"
  type        = string
}

variable "region" {
  description = "The aws region"
  type        = string
}