resource "vsphere_folder" "vm_folder" {
  path          = "tf-managed-networking-prod"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
