
data "vsphere_compute_cluster" "storage_cluster" {
  name          = "storage-cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster_host_group" "storage_cluster_hosts" {
  name               = "all"
  compute_cluster_id = data.vsphere_compute_cluster.storage_cluster.id
}

data "vsphere_host" "esxi_storage1" {
  name          = "esxi-storage1.int.ripplefcl.com"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "esxi_storage2" {
  name          = "esxi-storage2.int.ripplefcl.com"
  datacenter_id = data.vsphere_datacenter.dc.id
}
