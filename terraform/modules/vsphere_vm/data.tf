#===============================================================================
# vSphere Data
#===============================================================================

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = var.vsphere_datacenter_id
}


data "vsphere_datastore" "datastore" {
  name          = var.vm_datastore
  datacenter_id = var.vsphere_datacenter_id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = var.vsphere_datacenter_id
}
