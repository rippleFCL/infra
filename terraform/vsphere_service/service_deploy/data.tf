data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "storage_cluster" {
  name          = "storage-cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster_host_group" "storage_cluser_hosts" {
  name               = "all"
  compute_cluster_id = data.vsphere_compute_cluster.storage_cluster.id
}

data "vsphere_network" "vm_mgmt_net" {
  name          = "vm mgmt net"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "storage_cu_vm_vlan" {
  name          = "storage_cu_vm_vlan"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "storage_cu_vm_storage_vlan" {
  name          = "storage_cu_vm_storage_vlan"
  datacenter_id = data.vsphere_datacenter.dc.id
}



data "vsphere_datastore" "big-ssd-datastore" {
  name          = "big-ssd-datastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}
