#===============================================================================
# vSphere Provider
#===============================================================================


terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
    # ansible = {
    #   version = "~> 1.1.0"
    #   source  = "ansible/ansible"
    # }
  }
}





data "external" "bws_lookup" {
  program = ["python3", "../../bws_lookup.py"]
  query = {
    key = "vsphere_password,vsphere_user"
  }
}

# Configure the vSphere Provider
provider "vsphere" {
  vsphere_server = var.vsphere_vcenter
  user           = data.external.bws_lookup.result["vsphere_user"]
  password       = data.external.bws_lookup.result["vsphere_password"]

  allow_unverified_ssl = var.vsphere_unverified_ssl
}
