locals {
  name = "${var.project_name}-${var.environment}"
  tags = merge(var.extra_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "gitops-platform-eks"
  })
}

module "network" {
  source = "../network"

  name         = "${local.name}-vpc"
  vpc_cidr     = var.vpc_cidr
  az_count     = var.az_count
  nat_strategy = var.nat_strategy
  tags         = local.tags
}

module "eks_cluster" {
  source = "../eks-cluster"

  cluster_name                 = local.name
  kubernetes_version           = var.kubernetes_version
  vpc_id                       = module.network.vpc_id
  private_subnet_ids           = module.network.private_subnet_ids
  endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  instance_types               = var.instance_types
  node_min_size                = var.node_min_size
  node_desired_size            = var.node_desired_size
  node_max_size                = var.node_max_size
  log_retention_days           = var.log_retention_days
  tags                         = local.tags
}
