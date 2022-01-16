provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

module "Networking" {
  source = "./modules/Networking"
}

module "EKS" {
  source = "./modules/EKS"
  private-subnet-a = module.Networking.private-subnet-a
  private-subnet-b = module.Networking.private-subnet-b
  EKS-Cluster-SG = module.Networking.EKS-Cluster-SG
}