iso_url           = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.2.0-amd64-netinst.iso"
iso_checksum      = "23ab444503069d9ef681e3028016250289a33cc7bab079259b73100daee0af66"
iso_checksum_type = "sha256"
guest_username    = "ripple"
guest_fullname   = "ripplefcl"
ansible_username  = "ansible"

proxmox_url       = "10.0.1.30:8006"
proxmox_node      = "pve-workstation"
disk_pool         = "local-lvm"
iso_storage_pool  = "local"
disk_size         = "20G"
vm_ip_addr        = "10.0.5.10/24"
vm_name           = "debian-template"

ansible_inventory_dir = "../../ansible/environment/prod"


network_adaptors = [
    {
        driver  = "virtio",
        adapter = "vmbr0",
        vlan    = 10
    }
]
