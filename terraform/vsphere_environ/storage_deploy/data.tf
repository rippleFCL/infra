data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}


data "vsphere_network" "vm_mgmt_net" {
  name          = "vm mgmt net"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "storage_cu_esxi_storage_vlan" {
  name          = "storage_cu_esxi_storage_vlan"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "storage_cu_vm_storage_vlan" {
  name          = "storage_cu_vm_storage_vlan"
  datacenter_id = data.vsphere_datacenter.dc.id
}
