resource "vsphere_folder" "vm_folder" {
  path          = "tf-managed-storage-prod"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
