variable "vpc_cidr_block" {
  type = string
  description = "Cidr block of main vpc"
  default = "10.0.0.0/16"
}

variable "subnet1_cidr_block" {
  type = string
  description = "Cidr block of main vpc"
  default = "10.0.1.0/24"
}

variable "subnet2_cidr_block" {
  type = string
  description = "Cidr block of main vpc"
  default = "10.0.2.0/24"
}

variable "subnet3_cidr_block" {
  type = string
  description = "Cidr block of main vpc"
  default = "10.0.4.0/24"
}

variable "az1" {
  type = string
  description = "Availability zone 1 for subnets"
}

variable "az2" {
  type = string
  description = "Availability zone 2 for subnets"
}