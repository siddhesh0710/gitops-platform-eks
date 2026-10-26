variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "endpoint_public_access_cidrs" {
  description = "Trusted IPv4 CIDRs allowed to reach the public EKS API endpoint."
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

variable "tags" {
  type = map(string)
}
