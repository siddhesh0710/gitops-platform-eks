project_name = "gitops-platform"
environment  = "prod"
aws_region   = "ap-south-1"
kubernetes_version = "1.36"
vpc_cidr     = "10.30.0.0/16"
az_count     = 3
nat_strategy = "per_az"

# Replace with your trusted public IP, e.g. ["203.0.113.12/32"]. The value below is a documentation-only address.
cluster_endpoint_public_access_cidrs = ["203.0.113.10/32"]

instance_types    = ["t3.medium"]
node_min_size     = 3
node_desired_size = 3
node_max_size     = 8
log_retention_days = 90
extra_tags = {
  CostCenter = "portfolio-prod"
}
