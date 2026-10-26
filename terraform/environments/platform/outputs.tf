output "cluster_name" {
  description = "EKS cluster name for aws eks update-kubeconfig."
  value       = module.platform.cluster_name
}

output "cluster_endpoint" {
  value = module.platform.cluster_endpoint
}

output "cluster_arn" {
  value = module.platform.cluster_arn
}

output "vpc_id" {
  value = module.platform.vpc_id
}

output "public_subnet_ids" {
  value = module.platform.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.platform.private_subnet_ids
}

output "availability_zones" {
  value = module.platform.availability_zones
}

output "configure_kubectl_command" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.platform.cluster_name}"
}
