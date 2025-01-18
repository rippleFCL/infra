

# variable "  unverified_ssl" {
#   description = "Is the vCenter using a self signed certificate (true/false)"
#   default     = "true"
# }

variable "vm_os" {
  description = "the guest os"
}

variable "vsphere_datacenter_id" {
  description = "vSphere datacenter"
}

variable "vsphere_cluster" {
  description = "vSphere cluster"
  type        = string
}

#=========================#
# vSphere virtual machine #
#=========================#

variable "vm_datastore" {
  description = "Datastore used for the vSphere virtual machines"
}

variable "vm_template" {
  description = "Template used to create the vSphere virtual machines"
}

variable "vm_name" {
  description = "The name of the vSphere virtual machines"
}

variable "vm_hostname" {
  description = "The hostname of the vSphere virtual machines e"
  default     = null
}

variable "vm_domain" {
  description = "The domain of the vSphere virtual machines and the hostname of the machine"
}

variable "wait_for_ip" {
  description = "whether to wait for the "
  default     = true
  type        = bool
}


variable "vm_host_id" {
  description = "The host id to put place vm on"
  default     = null
}

variable "vm_tags" {
  description = "The host id to put place vm on"
  type        = list(string)
  default     = null
}

variable "vm_folder" {
  description = "The host id to put place vm on"
  type        = string
  default     = null
}

variable "spec" {
  type = object({
    enable_hv    = optional(bool)
    cpu          = number
    memory       = number
    disk_size    = number
    linked_clone = optional(bool)
    additional_network = optional(list(object({
      network = string
    })))
    additional_disks = optional(list(object({
      label        = optional(string)
      size         = number
      datastore_id = optional(string)
      attach_disk  = optional(bool)
    })))
  })
}

variable "network_spec" {
  type = list(object({
    network_id      = optional(string)
    mac_address     = optional(string)
    static_mac_addr = optional(bool)
  }))
}

variable "is_ha" {
  type    = bool
  default = true
}

variable "pcie_passthough" {
  type    = list(string)
  default = []
}
