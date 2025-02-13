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
    {
      name = "storage_cu_vm_vlan"
      vlan = 70
    },
    {
      name = "storage_cu_vm_mgmt"
      vlan = 10
    },
    {
      name = "storage_cu_vm_net_mgmt"
      vlan = 20
    },
    {
      name = "storage_cu_routing_trunk"
      vlan_range = [{
        min_vlan = 10,
        max_vlan = 4094
      }]
    },

  ]
  esxi_hosts_ids = data.vsphere_compute_cluster_host_group.storage_cluser_hosts.host_system_ids
}
