data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_network" "vm_net_mgmt" {
  name          = "storage_cu_vm_net_mgmt"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "storage_cu_routing_trunk" {
  name          = "storage_cu_routing_trunk"
  datacenter_id = data.vsphere_datacenter.dc.id
}
