variable "vsphere_datacenter" {
  description = "vSphere datacenter"
  type = string
}

variable "dvswitch_name" {
  description = "vSphere dvswitch name"
  type = string
}

variable "esxi_hosts_ids" {
  description = "the hosts to attach to dvswitch to"
  type = list(string)
}

variable "network_interfaces" {
  type = list(list(string))
}

variable "switch_links" {
  type = list(string)
}

variable "switch_standy_links" {
  type = list(string)
  default = []
}

variable "port_group" {
  default = []
  type = list(object({
    name = string,
    vlan = optional(string),
    type = optional(string),
    vlan_range = optional(list(object({
      min_vlan = optional(number),
      max_vlan = optional(number),
    })))
  }))
}
