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
    "/preseed.cfg" = templatefile("${abspath(path.root)}/files/preseed.pkrtpl.hcl", {
      user_fullname = var.guest_fullname
      user_name     = var.guest_username
      user_password = var.guest_password
    })
  }
}

source "vsphere-iso" "debian_12" {
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

  boot_command          = [
    "c<wait>",
    "linux /install.amd/vmlinuz ",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "priority=high ",
    "locale=en_GB.UTF-8 ",
    "keymap=gb ",
    "hostname=${var.vm_name} ",
    "domain=home.lan ",
    "---<enter>",
    "initrd /install.amd/initrd.gz<enter>",
    "boot<enter>"
  ]
  convert_to_template = true

}





source "null" "testing" {
  ssh_host = "10.69.255.39"
  ssh_username = "ditrames"
  ssh_password = var.guest_password
}

// build {
//   sources = [
//     "source.null.testing"
//   ]

build {
  name    = "template"
  sources = ["source.vsphere-iso.debian_12"]

  provisioner "ansible" {
    playbook_file = "../../ansible/playbooks/packer/bootstrap-debian-image.yml"
    extra_arguments     = [
      "-l",
      "deb-x12-template"
    ]
    use_proxy = false
    host_alias = "deb-x12-template"
    inventory_file = var.ansible_inventory_dir
  }
}

