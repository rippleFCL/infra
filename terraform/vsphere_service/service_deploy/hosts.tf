# data "vsphere_host" "esxi1" {
#   name          = "esxi1.int.ripplefcl.com"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

data "vsphere_host" "esxi2" {
  name          = "esxi2.int.ripplefcl.com"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_host" "esxi3" {
#   name          = "esxi3.int.ripplefcl.com"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# data "vsphere_host" "esxi-netcu1" {
#   name          = "esxi-netcu1.int.ripplefcl.com"
#   datacenter_id = data.vsphere_datacenter.dc.id
# }
