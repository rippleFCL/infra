#===============================================================================
# vSphere Modules
#===============================================================================

module "docker-gpu" {
  vm_os = "debian"

  vsphere_datacenter_id = data.vsphere_datacenter.dc.id

  count  = 1
  source = "../../modules/vsphere_vm"
  # vm_name         = "docker-${count.index+1}"
  vsphere_cluster = "storage-cluster"
  is_ha           = false
  vm_name         = "docker-gpu-${format("%02d", count.index + 1)}-prod"
  vm_hostname     = "docker-gpu-${format("%02d", count.index + 1)}"
  vm_host_id      = data.vsphere_host.esxi_storage2.id
  vm_template     = "deb-x12-template-prod"
  vm_domain       = "int.ripplefcl.com"
  vm_folder       = vsphere_folder.vm_folder.path
  vm_tags         = [vsphere_tag.docker-gpu-host.id, vsphere_tag.debian.id]


  #pcie passthrough
  pcie_passthough = ["0000:82:00.0"]

  # vsphere_cluster = var.vsphere_cluster
  vm_datastore = "big-ssd-datastore"
  network_spec = [
    {
      network_id = data.vsphere_network.storage_cu_vm_vlan.id
    },
    {
      network_id = data.vsphere_network.storage_cu_vm_storage_vlan.id
    },
  ]
  spec = {
    cpu       = 6
    memory    = 10000
    disk_size = 32
    additional_disks = [
      {
        size = 64
      }
    ]
  }
}

module "network-services-0" {
  vm_os = "debian"

  vsphere_datacenter_id = data.vsphere_datacenter.dc.id

  count           = 1
  source          = "../../modules/vsphere_vm"
  vsphere_cluster = "storage-cluster"
  vm_host_id      = data.vsphere_host.esxi_storage1.id
  is_ha           = false
  vm_name         = "network-services-01-prod"
  vm_hostname     = "network-services-01"
  vm_template     = "deb-x12-template-prod"
  vm_domain       = "int.ripplefcl.com"
  vm_folder       = vsphere_folder.vm_folder.path
  vm_tags         = [vsphere_tag.networking-services.id, vsphere_tag.debian.id]

  # vsphere_cluster = var.vsphere_cluster
  vm_datastore = "big-ssd-datastore"
  network_spec = [{
    network_id = data.vsphere_network.storage_cu_vm_vlan.id
  }]
  spec = {
    cpu       = 2
    memory    = 5120
    disk_size = 32
    additional_disks = [
      {
        size = 64
      }
    ]
  }
}

module "network-services-1" {
  vm_os = "debian"

  vsphere_datacenter_id = data.vsphere_datacenter.dc.id

  count           = 1
  source          = "../../modules/vsphere_vm"
  vsphere_cluster = "storage-cluster"
  vm_host_id      = data.vsphere_host.esxi_storage2.id

  is_ha       = false
  vm_name     = "network-services-02-prod"
  vm_hostname = "network-services-02"
  vm_template = "deb-x12-template-prod"
  vm_domain   = "int.ripplefcl.com"
  vm_folder   = vsphere_folder.vm_folder.path
  vm_tags     = [vsphere_tag.networking-services.id, vsphere_tag.debian.id]

  # vsphere_cluster = var.vsphere_cluster
  vm_datastore = "big-ssd-datastore"
  network_spec = [{
    network_id = data.vsphere_network.storage_cu_vm_vlan.id
  }]
  spec = {
    cpu       = 2
    memory    = 5120
    disk_size = 32
    additional_disks = [
      {
        size = 64
      }
    ]
  }
}

module "docker" {
  vm_os = "debian"

  vsphere_datacenter_id = data.vsphere_datacenter.dc.id

  count           = 1
  source          = "../../modules/vsphere_vm"
  vsphere_cluster = "storage-cluster"
  is_ha           = true
  vm_name         = "docker-${format("%02d", count.index + 1)}-prod"
  vm_hostname     = "docker-${format("%02d", count.index + 1)}"
  vm_template     = "deb-x12-template-prod"
  vm_domain       = "int.ripplefcl.com"
  vm_folder       = vsphere_folder.vm_folder.path
  vm_tags         = [vsphere_tag.docker-host.id, vsphere_tag.debian.id]

  # vsphere_cluster = var.vsphere_cluster
  vm_datastore = "big-ssd-datastore"
  network_spec = [{
    network_id = data.vsphere_network.storage_cu_vm_vlan.id
  }]
  spec = {
    cpu       = 2
    memory    = 5120
    disk_size = 32
    additional_disks = [
      {
        size = 64
      }
    ]
  }
}

module "docker-proxy-internal" {
  vm_os = "debian"

  vsphere_datacenter_id = data.vsphere_datacenter.dc.id

  count           = 1
  source          = "../../modules/vsphere_vm"
  vsphere_cluster = "storage-cluster"
  is_ha           = true
  vm_name         = "proxy-internal-${format("%02d", count.index + 1)}-prod"
  vm_hostname     = "proxy-internal-${format("%02d", count.index + 1)}"
  vm_template     = "deb-x12-template-prod"
  vm_domain       = "int.ripplefcl.com"
  vm_folder       = vsphere_folder.vm_folder.path
  vm_tags         = [vsphere_tag.docker-host.id, vsphere_tag.debian.id, vsphere_tag.proxy-hosts.id]

  # vsphere_cluster = var.vsphere_cluster
  vm_datastore = "big-ssd-datastore"
  network_spec = [{
    network_id = data.vsphere_network.storage_cu_vm_vlan.id
  }]
  spec = {
    cpu       = 2
    memory    = 5120
    disk_size = 32
    additional_disks = [
      {
        size = 10
      }
    ]
  }
}

module "docker-proxy-external" {
  vm_os = "debian"

  vsphere_datacenter_id = data.vsphere_datacenter.dc.id

  count           = 1
  source          = "../../modules/vsphere_vm"
  vsphere_cluster = "storage-cluster"
  is_ha           = true
  vm_name         = "proxy-external-${format("%02d", count.index + 1)}-prod"
  vm_hostname     = "proxy-external-${format("%02d", count.index + 1)}"
  vm_template     = "deb-x12-template-prod"
  vm_domain       = "int.ripplefcl.com"
  vm_folder       = vsphere_folder.vm_folder.path
  vm_tags         = [vsphere_tag.docker-host.id, vsphere_tag.debian.id, vsphere_tag.proxy-hosts.id]

  # vsphere_cluster = var.vsphere_cluster
  vm_datastore = "big-ssd-datastore"
  network_spec = [{
    network_id = data.vsphere_network.storage_cu_vm_vlan.id
  }]
  spec = {
    cpu       = 2
    memory    = 5120
    disk_size = 32
    additional_disks = [
      {
        size = 10
      }
    ]
  }
}

module "mainsail" {
  vm_os = "debian"

  vsphere_datacenter_id = data.vsphere_datacenter.dc.id

  source          = "../../modules/vsphere_vm"
  vsphere_cluster = "storage-cluster"
  vm_host_id      = data.vsphere_host.esxi_storage1.id
  is_ha           = false
  vm_name         = "3d-printer-prod"
  vm_hostname     = "3d-printer"
  vm_template     = "deb-x12-template-prod"
  vm_domain       = "int.ripplefcl.com"
  vm_folder       = vsphere_folder.vm_folder.path
  vm_tags         = [vsphere_tag.mainsail-host.id, vsphere_tag.debian.id]

  # vsphere_cluster = var.vsphere_cluster
  vm_datastore = "big-ssd-datastore"
  network_spec = [{
    network_id = data.vsphere_network.storage_cu_vm_vlan.id
  }]
  spec = {
    cpu       = 2
    memory    = 5120
    disk_size = 32
  }
}
