variable "project_name" {
  type = string
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "aws_region" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az_count" {
  type = number
}

variable "nat_strategy" {
  type = string
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "Trusted IPv4 CIDRs allowed to reach the public EKS API endpoint. Replace the documentation-only CIDR in env/*.tfvars."
  type        = list(string)
}

variable "instance_types" {
  type = list(string)
}

variable "node_min_size" {
  type = number
}

variable "node_desired_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "log_retention_days" {
  type = number
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
