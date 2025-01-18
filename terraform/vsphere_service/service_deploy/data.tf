data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}


data "vsphere_compute_cluster" "compute_cluster" {
  name          = "compute-cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster_host_group" "compute_cluser_hosts" {
  name               = "all"
  compute_cluster_id = data.vsphere_compute_cluster.compute_cluster.id
}




data "vsphere_compute_cluster" "networking_cluster" {
  name          = "networking-cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster_host_group" "networking_cluster_hosts" {
  name               = "all"
  compute_cluster_id = data.vsphere_compute_cluster.networking_cluster.id
}

data "vsphere_network" "vm_mgmt_net" {
  name          = "vm mgmt net"
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_network" "compute_cu_vm_vlan" {
  name          = "compute_cu_vm_vlan"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "compute_cu_vm_storage_vlan" {
  name          = "compute_cu_vm_storage_vlan"
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_datastore" "ssd-datastore" {
  name          = "ssd-datastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}
