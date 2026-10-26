project_name = "gitops-platform"
environment  = "dev"
aws_region   = "ap-south-1"
kubernetes_version = "1.36"
vpc_cidr     = "10.20.0.0/16"
az_count     = 2
nat_strategy = "single"

# Replace with your trusted public IP, e.g. ["203.0.113.12/32"]. The value below is a documentation-only address.
cluster_endpoint_public_access_cidrs = ["203.0.113.10/32"]

instance_types    = ["t3.medium"]
node_min_size     = 1
node_desired_size = 2
node_max_size     = 3
log_retention_days = 30
extra_tags = {
  CostCenter = "portfolio-dev"
}
