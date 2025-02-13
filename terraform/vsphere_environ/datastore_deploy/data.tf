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
