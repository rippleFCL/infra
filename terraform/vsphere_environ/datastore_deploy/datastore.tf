resource "vsphere_nas_datastore" "ssd-datastore" {
  name            = "ssd-datastore"
  host_system_ids = setunion(
    data.vsphere_compute_cluster_host_group.storage_cluser_hosts.host_system_ids,
  )


  type         = "NFS"
  remote_hosts = ["10.2.1.1"]
  remote_path  = "/ssd-pool/ssd-nas/vcenter/nfs/"
}

resource "vsphere_nas_datastore" "big-ssd-datastore" {
  name            = "big-ssd-datastore"
  host_system_ids = setunion(
    data.vsphere_compute_cluster_host_group.storage_cluser_hosts.host_system_ids,
  )


  type         = "NFS"
  remote_hosts = ["10.2.1.1"]
  remote_path  = "/big-ssd-pool/ssd-nas/vcenter/"
}


resource "vsphere_nas_datastore" "hdd-datastore" {
  name            = "hdd-datastore"
  host_system_ids = setunion(
    data.vsphere_compute_cluster_host_group.storage_cluser_hosts.host_system_ids,
  )


  type         = "NFS"
  remote_hosts = ["10.2.1.10"]
  remote_path  = "/hdd-pool/hdd-nas/vcenter/nfs/"
}

