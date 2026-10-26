variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az_count" {
  type = number
  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be 2 or 3 for this project."
  }
}

variable "nat_strategy" {
  type = string
  validation {
    condition     = contains(["single", "per_az"], var.nat_strategy)
    error_message = "nat_strategy must be either single or per_az."
  }
}

variable "tags" {
  type = map(string)
}
