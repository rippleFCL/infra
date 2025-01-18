module "storage-ssd-nas" {
  vsphere_datacenter_id = data.vsphere_datacenter.dc.id
  source = "../../modules/vsphere_vm"
  vm_name         = "storage-ssd-nas-prod"
  vm_hostname     = "storage-ssd-nas"
  vm_domain = "int.ripplefcl.com"
  vm_os = "debian"
  vm_template     = "nas-template-prod"
  vsphere_cluster = "storage-cluster"
  vm_host_id = data.vsphere_host.esxi_storage1.id

  pcie_passthough = ["0000:03:00.0"]
  is_ha = false

  vm_folder = vsphere_folder.vm_folder.path
  vm_tags   = [vsphere_tag.nas.id, vsphere_tag.debian.id]

  vm_datastore = "ds-esxi-storage1"
  network_spec = [
    {
      network_id = data.vsphere_network.vm_mgmt_net.id
    },
    {
      network_id = data.vsphere_network.storage_cu_esxi_storage_vlan.id
    },
    {
      network_id = data.vsphere_network.storage_cu_vm_storage_vlan.id
    }
  ]
  spec = {
    cpu       = 12
    memory    = 102400
    disk_size = 16
  }
}

module "storage-hdd-nas" {
  vsphere_datacenter_id = data.vsphere_datacenter.dc.id
  source = "../../modules/vsphere_vm"
  vm_name         = "storage-hdd-nas-prod"
  vm_hostname     = "storage-hdd-nas"
  vm_domain = "int.ripplefcl.com"
  vm_os = "debian"
  vm_template     = "nas-template-prod"
  vsphere_cluster = "storage-cluster"
  vm_host_id = data.vsphere_host.esxi_storage2.id

  pcie_passthough = ["0000:03:00.0"]
  is_ha = false

  vm_folder = vsphere_folder.vm_folder.path
  vm_tags   = [vsphere_tag.nas.id, vsphere_tag.debian.id]

  vm_datastore = "ds-esxi-storage2"
  network_spec = [
    {
      network_id = data.vsphere_network.vm_mgmt_net.id
    },
    {
      network_id = data.vsphere_network.storage_cu_esxi_storage_vlan.id
    },
    {
      network_id = data.vsphere_network.storage_cu_vm_storage_vlan.id
    }
  ]
  spec = {
    cpu       = 12
    memory    = 40000
    disk_size = 16
  }
}
