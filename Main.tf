module "k8s_cluster" {
  source = "./Modules/Cluster"

  cluster_name = var.cluster_name
  instance_type = var.instance_type

  vpc_id = module.network.vpc_id
  private_subnet1 = module.network.private_subnet1_id
  private_subnet2 = module.network.private_subnet2_id

  desired_nodes = 2
  max_nodes = 5
  min_nodes = 1
  region = var.region

  runner_token = var.runner_token
}

module "network" {
  source = "./Modules/Network"

  az1 = "${var.region}a"
  az2 = "${var.region}b"
}