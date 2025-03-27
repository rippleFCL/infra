module "core-fw-cu" {
  vm_domain             = "int.ripplefcl.com"
  vsphere_datacenter_id = data.vsphere_datacenter.dc.id
  count                 = 2
  source                = "../../modules/vsphere_vm"
  vm_name               = "core-fw-cu-${format("%02d", count.index + 1)}-prod"
  vm_os                 = "freebsd"
  vm_template           = "freebsd-13-3-template"
  vsphere_cluster       = "storage-cluster"

  wait_for_ip = false

  vm_folder = vsphere_folder.vm_folder.path
  vm_tags   = [vsphere_tag.int-fw-cu.id, vsphere_tag.opnsense.id, ]

  vm_datastore = "big-ssd-datastore"
  network_spec = [
    {
      network_id = data.vsphere_network.vm_net_mgmt.id
    },
    {
      network_id = data.vsphere_network.storage_cu_routing_trunk.id
    },
    {
      network_id = data.vsphere_network.wifi.id
    },
    {
      network_id = data.vsphere_network.guest_wifi.id
    },
    {
      network_id = data.vsphere_network.mgmt_net.id
    }
  ]
  spec = {
    cpu          = 4
    memory       = 2000
    disk_size    = 16
    linked_clone = true
  }
}

module "gateway-fw-cu" {
  vm_domain             = "ext.ripplefcl.com"
  vsphere_datacenter_id = data.vsphere_datacenter.dc.id
  count                 = 1
  source                = "../../modules/vsphere_vm"
  vm_name               = "gateway-fw-01-prod"
  vm_os                 = "freebsd"
  vm_template           = "freebsd-13-3-template"
  vsphere_cluster       = "storage-cluster"
  vm_host_id            = data.vsphere_host.esxi_storage1.id


  vm_folder = vsphere_folder.vm_folder.path
  vm_tags   = [vsphere_tag.gw-fw-cu.id, vsphere_tag.opnsense.id, ]

  wait_for_ip = false


  vm_datastore = "big-ssd-datastore"
  network_spec = [
    {
      network_id = data.vsphere_network.vm_net_mgmt.id
    },
    {
      network_id = data.vsphere_network.wan_conn.id
    },
    {
      network_id = data.vsphere_network.storage_cu_routing_trunk.id
    }
  ]
  spec = {
    cpu          = 4
    memory       = 2000
    disk_size    = 16
    linked_clone = true
  }
}

module "gateway-fw-cu-secondary" {
  vm_domain             = "ext.ripplefcl.com"
  vsphere_datacenter_id = data.vsphere_datacenter.dc.id
  count                 = 1
  source                = "../../modules/vsphere_vm"
  vm_name               = "gateway-fw-02-prod"
  vm_os                 = "freebsd"
  vm_template           = "freebsd-13-3-template"
  vsphere_cluster       = "storage-cluster"
  vm_host_id            = data.vsphere_host.esxi_storage2.id


  vm_folder = vsphere_folder.vm_folder.path
  vm_tags   = [vsphere_tag.gw-fw-cu.id, vsphere_tag.opnsense.id, ]

  wait_for_ip = false


  vm_datastore = "big-ssd-datastore"
  network_spec = [
    {
      network_id = data.vsphere_network.vm_net_mgmt.id
    },
    {
      network_id = data.vsphere_network.wan_conn.id
    },
    {
      network_id = data.vsphere_network.storage_cu_routing_trunk.id
    }
  ]
  spec = {
    cpu          = 4
    memory       = 2000
    disk_size    = 16
    linked_clone = true
  }
}
