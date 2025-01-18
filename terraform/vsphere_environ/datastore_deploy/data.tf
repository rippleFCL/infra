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
