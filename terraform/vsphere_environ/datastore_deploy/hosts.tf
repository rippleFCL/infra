data "vsphere_host" "esxi_storage1" {
  name          = "esxi-storage1.int.ripplefcl.com"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "esxi_storage2" {
  name          = "esxi-storage2.int.ripplefcl.com"
  datacenter_id = data.vsphere_datacenter.dc.id
}
