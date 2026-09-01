data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "kubernetes-smalll-project"
    key = "vpc/dev/terraform.tfstate"
    region = var.aws_region
  }
}

output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "private_subnet_id" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

output "public_subnet_id" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}

