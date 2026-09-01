locals {
  owners = var.bussiness_division

  environment = var.environment_name

  name = "${local.owners}-${local.environment}"

  eks-cluster_name = "${local.owners}-${var.cluster_name}"
}