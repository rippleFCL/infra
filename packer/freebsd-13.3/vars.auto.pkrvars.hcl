datacenter            = "ripple-labs"
cluster               = "networking-cluster"
datastore             = "ds-netcu2"
network_name          = "vm mgmt net"
iso_url               = "https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/13.3/FreeBSD-13.3-RELEASE-amd64-dvd1.iso"
iso_checksum          = "4064f704baadf204ab4f75dda987e717b8da252840675ee5feef8f5be7e9356c"
iso_checksum_type     = "sha256"
vm_cpu_num            = "1"
vm_mem_size           = "1024"
vm_disk_size          = "16000"
vm_name               = "freebsd-13-3-template"
guest_os_version      = "freebsd13_64Guest"
guest_fullname        = "ripplefcl"
guest_username        = "root"
vsphere_server        = "vcsa.int.ripplefcl.com"
guest_hostname        = "freebsd-template"
ssh_public_key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9k+kvyR7NeIGbf/PFYpOpd5K1V9epUhwq+ZIpmiHcP ripple@ripplefcl.com"
template_folder       = "i-use-packer"
