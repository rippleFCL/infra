#===============================================================================
# vSphere Provider
#===============================================================================


terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.1"
    }
    gravity = {
      source  = "BeryJu/gravity"
      version = "0.3.7"
    }
  }
  cloud {
    organization = "ripplefcl"
    workspaces {
      name = "infra-service-provision"
    }
  }
}




data "external" "bws_lookup" {
  program = ["python3", "../../bws_lookup.py"]
  query = {
    key = "vsphere_password,vsphere_user,gravity_join_token"
  }
}

# Configure the vSphere Provider
provider "vsphere" {
  vsphere_server = var.vsphere_vcenter
  user           = data.external.bws_lookup.result["vsphere_user"]
  password       = data.external.bws_lookup.result["vsphere_password"]

  allow_unverified_ssl = var.vsphere_unverified_ssl
}

provider "gravity" {
  url = "http://10.0.7.10:8008"
  # Ignore Certificate errors when using HTTPS
  insecure = true
  token    = data.external.bws_lookup.result["gravity_join_token"]
}
