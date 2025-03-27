data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_network" "mgmt_net" {
  name          = "vm mgmt net"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "vm_net_mgmt" {
  name          = "storage_cu_vm_net_mgmt"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "wan_conn" {
  name          = "wan_conn"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "storage_cu_routing_trunk" {
  name          = "storage_cu_routing_trunk"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "wifi" {
  name          = "wifi"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "guest_wifi" {
  name          = "guest_wifi"
  datacenter_id = data.vsphere_datacenter.dc.id
}

