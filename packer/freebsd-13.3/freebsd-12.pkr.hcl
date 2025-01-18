packer {
  required_version = ">= 1.8.4"
  required_plugins {
    vsphere = {
      version = ">= v1.2.0"
      source  = "github.com/hashicorp/vsphere"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

locals {
  preseed_config = {
    "/installerconfig" = templatefile("${abspath(path.root)}/files/installconfig.pkrtpl.hcl", {
      user_password = var.guest_password
      hostname = var.guest_hostname
    }),
    "/postinstall" = templatefile("${abspath(path.root)}/files/postinstall.pkrtpl.hcl", {})
  }
}

source "vsphere-iso" "freebsd_13" {
  firmware      = "efi"
  vcenter_server    = var.vsphere_server
  username          = var.vsphere_user
  password          = var.vsphere_password
  datacenter        = var.datacenter
  datastore         = var.datastore
  cluster           = var.cluster
  insecure_connection  = true

  folder=var.template_folder
  vm_name = var.vm_name
  guest_os_type = var.guest_os_version

  ssh_username = var.guest_username
  ssh_password = var.guest_password

  http_content = local.preseed_config

  CPUs         = var.vm_cpu_num
  RAM          = var.vm_mem_size
  RAM_reserve_all = true

  disk_controller_type =  ["lsilogic-sas"]
  storage {
    disk_size = var.vm_disk_size
    disk_thin_provisioned = true
  }

  iso_checksum		      = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_url				        = var.iso_url
  network_adapters {
    network =  var.network_name
    network_card = "vmxnet3"
  }
  boot_wait="5s"
  boot_command          = [
    "<esc><wait>",
    "boot -s<enter>",
    "<wait15s>",
    "/bin/sh<enter><wait>",
    "mdmfs -s 100m md /tmp<enter><wait>",
    "dhclient -l /tmp/dhclient.lease.vmx0 vmx0<enter><wait5>",
    "fetch -o /tmp/installerconfig http://{{ .HTTPIP }}:{{ .HTTPPort }}/installerconfig<enter><wait5>",
    "bsdinstall script /tmp/installerconfig<enter>",
    "<wait20><wait20><wait20>",
    "root<enter><wait>",
    var.guest_password,
    "<enter><wait>",
    "fetch -o /tmp/postinstall http://{{ .HTTPIP }}:{{ .HTTPPort }}/postinstall<enter><wait5>",
    "chmod +x /tmp/postinstall<enter><wait>",
    "/tmp/postinstall<enter>"

  ]
  convert_to_template = true

}


build {
  name    = "freebsd-template"
  sources = ["source.vsphere-iso.freebsd_13"]
}

