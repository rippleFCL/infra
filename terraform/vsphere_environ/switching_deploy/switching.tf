module "storage_cu_dvswitch" {
  source = "../../modules/vsphere_dvswitch"
  dvswitch_name = "storage-cu-dvswitch"
  vsphere_datacenter = data.vsphere_datacenter.dc.id

  switch_links = ["uplink1", "uplink2"]
  network_interfaces = [
    for id in data.vsphere_compute_cluster_host_group.storage_cluser_hosts.host_system_ids : ["vmnic4", "vmnic5"]
  ]

  port_group = [
    {
      name = "storage_cu_esxi_migration_vlan"
      vlan = 210
    },
    {
      name = "storage_cu_esxi_storage_vlan"
      vlan = 200
    },
    {
      name = "storage_cu_vm_storage_vlan"
      vlan = 220
    },

  ]
  esxi_hosts_ids = data.vsphere_compute_cluster_host_group.storage_cluser_hosts.host_system_ids
}

module "compute-cu-dvswitch" {
  source = "../../modules/vsphere_dvswitch"
  dvswitch_name = "compute-cu-dvswitch"
  vsphere_datacenter = data.vsphere_datacenter.dc.id

  switch_links = ["uplink1", "uplink2"]
  network_interfaces = [
    for id in data.vsphere_compute_cluster_host_group.compute_cluser_hosts.host_system_ids : ["vmnic4", "vmnic5"]
  ]

  port_group = [
    {
      name = "compute_cu_vm_mgmt"
      vlan = 10
    },
    {
      name = "compute_cu_vm_vlan"
      vlan = 60
    },
    {
      name = "compute_cu_esxi_storage_vlan"
      vlan = 200
    },
    {
      name = "compute_cu_esxi_migration_vlan"
      vlan = 210
    },
    {
      name = "compute_cu_vm_storage_vlan"
      vlan = 220
    },
  ]
  esxi_hosts_ids = data.vsphere_compute_cluster_host_group.compute_cluser_hosts.host_system_ids

}

module "network_cu_dvswitch" {
  source = "../../modules/vsphere_dvswitch"
  dvswitch_name = "networking-cu-dvswitch"
  vsphere_datacenter = data.vsphere_datacenter.dc.id

  switch_links = ["uplink1", "uplink2"]
  network_interfaces = [
    for id in data.vsphere_compute_cluster_host_group.networking_cluster_hosts.host_system_ids : ["vmnic2", "vmnic3"]
  ]

  port_group = [
    {
      name = "networking_cu_routing_trunk"
      vlan_range = [{
        min_vlan = 20,
        max_vlan = 2000
      }]
    },
    {
      name = "networking_cu_esxi_storage_vlan"
      vlan = 200
    },
    {
      name = "networking_cu_esxi_migration_vlan"
      vlan = 210
    }
  ]
  esxi_hosts_ids = data.vsphere_compute_cluster_host_group.networking_cluster_hosts.host_system_ids
}
