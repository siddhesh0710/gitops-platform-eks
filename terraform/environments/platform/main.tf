module "platform" {
  source = "../../modules/platform"

  project_name                         = var.project_name
  environment                          = var.environment
  aws_region                           = var.aws_region
  kubernetes_version                   = var.kubernetes_version
  vpc_cidr                             = var.vpc_cidr
  az_count                             = var.az_count
  nat_strategy                         = var.nat_strategy
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  instance_types                       = var.instance_types
  node_min_size                        = var.node_min_size
  node_desired_size                    = var.node_desired_size
  node_max_size                        = var.node_max_size
  log_retention_days                   = var.log_retention_days
  extra_tags                           = var.extra_tags
}
