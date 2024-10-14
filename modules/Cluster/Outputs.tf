output "priamry_sg" {
  value = module.eks.cluster_primary_security_group_id
}

output "node_sg" {
  value = module.eks.node_security_group_id
}