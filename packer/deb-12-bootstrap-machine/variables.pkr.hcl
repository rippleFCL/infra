variable "guest_password" {
    type = string
}

variable "guest_username" {
    type = string
}

variable "guest_fullname" {
    type = string
}

variable "ansible_username" {
    type = string
}

variable "ansible_password" {
    type = string
}


variable "ssh_timeout" {
    type = string
    default = "15m"
}

variable "disk_pool" {
    type = string
}

variable "disk_size" {
    type = string
}

variable "network_adaptors" {
    type = list(
        object({
            driver = string,
            adapter = string,
            vlan = string,
        })
    )
}

variable "proxmox_node" {
    type = string
}

variable "proxmox_url" {
    type = string
}

variable "proxmox_username" {
    type = string
}

variable "proxmox_token" {
    type = string
}

variable "iso_url" {
    type = string
}

variable "iso_checksum" {
	type    = string
}

variable "iso_checksum_type" {
	type    = string
}

variable "iso_storage_pool" {
    type = string
}

variable "vm_ip_addr" {
    type = string
}

variable "vm_name" {
    type = string
}


variable "ansible_inventory_dir" {
	type    = string
}