#====================#
# vCenter connection #
#====================#

variable "vsphere_vcenter" {
  description = "vCenter server FQDN or IP"
  type        = string
}

variable "vsphere_unverified_ssl" {
  description = "Is the vCenter using a self signed certificate (true/false)"
  type        = string
}

variable "vsphere_datacenter" {
  description = "name of the vsphere datacenter"
  type        = string
}
