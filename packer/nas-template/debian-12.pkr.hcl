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

source "vsphere-iso" "debian_12_nas" {
  datastore = var.vm_datastore
  vm_name = var.vm_name
  firmware      = "efi"
  vcenter_server    = var.vsphere_server
  username          = var.vsphere_user
  password          = var.vsphere_password
  datacenter        = var.datacenter
  cluster           = var.cluster
  insecure_connection  = true

  folder=var.template_folder
  guest_os_type = var.guest_os_version

  ssh_username = var.guest_username
  ssh_password = var.guest_password

  http_content = local.preseed_config

  CPUs         = var.vm_cpu_num
  RAM          = var.vm_mem_size
  RAM_reserve_all = true

  disk_controller_type =  ["pvscsi"]
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
    "hostname=nas-template ",
    "domain=home.lan ",
    "---<enter>",
    "initrd /install.amd/initrd.gz<enter>",
    "boot<enter>"
  ]
  convert_to_template = true
}

build {
  name    = "template"
  source "source.vsphere-iso.debian_12_nas"{

  }

  provisioner "ansible" {
    ansible_env_vars        = ["ANSIBLE_CONFIG=../../ansible/ansible.cfg"]
    extra_arguments     = [
      "-l",
      "nas-template"
    ]
    playbook_file = "../../ansible/playbooks/packer/bootstrap-debian-image.yml"
    use_proxy = false
    host_alias = "nas-template"
    inventory_file = var.ansible_inventory_dir
  }
}

