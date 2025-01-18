data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_network" "vm_mgmt_net" {
  name          = "vm mgmt net"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "networking_cu_routing_trunk" {
  name          = "networking_cu_routing_trunk"
  datacenter_id = data.vsphere_datacenter.dc.id
}
