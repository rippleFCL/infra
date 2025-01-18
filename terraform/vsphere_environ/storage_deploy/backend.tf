terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "ripplefcl"

    workspaces {
      name = "infra-storage-deploy"
    }
  }
}