provider "aws"{
    region= "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "mys3demopolicy"
    key = "prod/terraform.tfstate"
    region = "us-west-2"
  }
}

module "s3" {
    source = "../module"
    env = var.env
    project_name = var.project_name
  
}