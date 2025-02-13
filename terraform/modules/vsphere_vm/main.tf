#===============================================================================
# vSphere Resources
#===============================================================================

resource "vsphere_virtual_machine" "vm" {

  name               = "${var.vm_name}"
  resource_pool_id   = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id       = data.vsphere_datastore.datastore.id
  host_system_id     = var.vm_host_id
  num_cpus           = var.spec.cpu
  memory             = var.spec.memory
  memory_reservation = length(var.pcie_passthough) == 0 ? null : var.spec.memory
  guest_id           = data.vsphere_virtual_machine.template.guest_id

  pci_device_id = var.pcie_passthough

  firmware = "efi"

  sync_time_with_host = true

  tags   = var.vm_tags
  folder = var.vm_folder

  wait_for_guest_net_timeout = var.wait_for_ip ? 5 : 0

  dynamic "network_interface" {
    for_each = var.network_spec
    content {
      network_id     = network_interface.value.network_id
      adapter_type   = "vmxnet3"
      use_static_mac = network_interface.value.static_mac_addr
      mac_address    = network_interface.value.mac_address != null ? network_interface.mac_address : ""
    }
  }
  disk {
    label = "boot-disk.vmdk"
    size  = var.spec.disk_size
  }

  dynamic "disk" {
    for_each = var.spec.additional_disks != null ? var.spec.additional_disks : []
    content {

      label            = "extra-disk-${disk.key}"
      datastore_id     = disk.value.datastore_id != null ? disk.value.datastore_id : null
      attach           = disk.value.attach_disk
      size             = disk.value.size
      eagerly_scrub    = false
      thin_provisioned = true
      keep_on_remove   = true
      unit_number      = disk.key + 1
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.spec.linked_clone
  }

  lifecycle {
    ignore_changes = [
      firmware,
      # clone[0].customize,
      # pci_device_id,
      clone,
      ept_rvi_mode,
      hv_mode,
    ]
  }

}

resource "vsphere_drs_vm_override" "drs_vm_override" {
  count              = var.is_ha == false ? 1 : 0
  compute_cluster_id = data.vsphere_compute_cluster.cluster.id
  virtual_machine_id = vsphere_virtual_machine.vm.id
  drs_enabled        = false
}

resource "vsphere_ha_vm_override" "ha_vm_override" {
  count              = var.is_ha == false ? 1 : 0
  compute_cluster_id = data.vsphere_compute_cluster.cluster.id
  virtual_machine_id = vsphere_virtual_machine.vm.id

  ha_vm_restart_priority = "disabled"
}
