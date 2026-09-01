variable "aws_region" {
    description = "region of the aws"
    type = string
    default = "us-east-1"
}

variable "environment_name" {
  description = "resources name and tags"
  type = string
  default = "dev"
}

variable "bussiness_division" {
  description = "bussiness division infrastructure belongs to"
  type = string
  default = "retail"
}

variable "cluster_name" {
    description = "name of the eks cluster"
    type = string
    default = "eks_demo"
}

variable "cluster_version" {
    description = "version of the eks cluster"
    type = string
    default = "1.34"
}

variable "cluster_service_ipv4_cidr" {
  description = "service cidr range"
  type = string
  default = null
}

variable "cluster_endpoint_private_access" {
  description = "enabel the private access"
  type = bool
  default = false
}

variable "cluster_endpoint_public_access" {
  description = "enabel the public access"
  type = bool
  default = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "cidrs for public access"
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "tags" {
  description = "tags for cost allocation and general idea"
  type = map(string)
  default = {
    Terraform = "true "
  }
}

variable "node_instance_type" {
  description = "list of ec2 instance for this project"
  type = list(string)
  default = [ "t3.micro" ]
}

variable "node_capacity_type" {
  description = "capacity type"
  type = string
  default = "ON_DEMAND"
}

variable "node_disk_size" {
  description = "disk size in gb"
  type = number
  default = 20
}