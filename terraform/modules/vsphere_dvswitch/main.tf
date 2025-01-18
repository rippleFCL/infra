#===============================================================================
# vSphere DVSWITCH Resources
#===============================================================================


resource "vsphere_distributed_virtual_switch" "vds" {
  name          = var.dvswitch_name
  datacenter_id = var.vsphere_datacenter

  uplinks         = var.switch_links
  active_uplinks  = [for link in var.switch_links: link if !contains(var.switch_standy_links, link)]
  standby_uplinks = var.switch_standy_links

  dynamic "host" {
    for_each = zipmap(var.esxi_hosts_ids, var.network_interfaces)
    content {
      host_system_id = host.key
      devices        = host.value
    }
  }
}

resource "vsphere_distributed_port_group" "pg" {
  for_each = toset([for x in range(length(var.port_group)): tostring(x)])

  name     = "${var.port_group[tonumber(each.value)].name}"
  vlan_id  = lookup(var.port_group[tonumber(each.value)], "vlan", null)
  type  = lookup(var.port_group[tonumber(each.value)], "type", "earlyBinding")
  auto_expand = lookup(var.port_group[tonumber(each.value)], "type", "earlyBinding") == "earlyBinding" ?  false : true
  dynamic "vlan_range" {
    for_each = var.port_group[tonumber(each.value)].vlan_range != null ? var.port_group[tonumber(each.value)].vlan_range : []
    content {
      min_vlan = vlan_range.value.min_vlan
      max_vlan = vlan_range.value.max_vlan
      }
  }
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.vds.id
}
