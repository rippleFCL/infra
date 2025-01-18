packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
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


source "proxmox-iso" "debian_12" {
  boot_command = [
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

  boot_wait       = "10s"
  scsi_controller = "virtio-scsi-single"
  bios            = "ovmf"
  machine         = "q35"

  efi_config {
    efi_storage_pool = "local-lvm"
    efi_type         = "4m"
  }

  disks {
    disk_size    = var.disk_size
    storage_pool = var.disk_pool
    type         = "scsi"
  }

  http_content             = local.preseed_config
  insecure_skip_tls_verify = true

  iso_storage_pool = var.iso_storage_pool
  iso_url          = var.iso_url
  iso_checksum     = "${var.iso_checksum_type}:${var.iso_checksum}"

  dynamic "network_adapters" {
    for_each = var.network_adaptors
    content {
      bridge   = network_adapters.value.adapter
      model    = network_adapters.value.driver
      vlan_tag = network_adapters.value.vlan
    }
  }

  memory      = 2000
  cores       = 16
  node        = var.proxmox_node
  token       = var.proxmox_token
  proxmox_url = "https://${var.proxmox_url}/api2/json"
  username    = var.proxmox_username

  ssh_password = var.guest_password
  ssh_timeout  = var.ssh_timeout
  ssh_username = var.guest_username

  template_description = "debian templated made on: ${timestamp()}"
  unmount_iso          = true
}


source "null" "testing" {
  ssh_host     = "10.0.5.184"
  ssh_username = "ripple"
  ssh_password = var.guest_password
}

// build {
//   sources = [
//     "source.null.testing"
//   ]

build {
  source "source.proxmox-iso.debian_12" {
    template_name = "debian-server-base"
    vm_id         = 4000
  }

  name = "template"
  provisioner "ansible" {
    host_alias    = "debian-template"
    playbook_file = "../../ansible/playbooks/packer/bootstrap-debian-image.yml"
    use_proxy     = false
    extra_arguments = [
      "-e",
      "ansible_password=${var.ansible_password}",
      "-e",
      "ansible_username=${var.ansible_username}",
      "-e",
      "ansible_password=${var.guest_password}",
      "-e",
      "ansible_become_pass=${var.guest_password}",
      "-e",
      "ansible_user=${var.guest_username}",
      "-e",
      "guest_username=${var.guest_username}"

    ]
    ansible_env_vars    = ["ANSIBLE_CONFIG=../../ansible/ansible.cfg"]
    inventory_directory = var.ansible_inventory_dir
  }
}

