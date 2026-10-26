module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids

  endpoint_private_access      = true
  endpoint_public_access       = true
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs

  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true

  enabled_log_types                      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = var.log_retention_days

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni    = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    general = {
      name           = "${var.cluster_name}-general"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.instance_types
      capacity_type  = "ON_DEMAND"

      min_size     = var.node_min_size
      desired_size = var.node_desired_size
      max_size     = var.node_max_size
      subnet_ids   = var.private_subnet_ids

      labels = {
        environment = split("-", var.cluster_name)[length(split("-", var.cluster_name)) - 1]
        workload    = "general"
      }
    }
  }

  tags = var.tags
}
