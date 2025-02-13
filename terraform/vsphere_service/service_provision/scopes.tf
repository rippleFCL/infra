locals {
  dhcp_scopes = tomap({
    mgmt       = {
      subnet_cidr = "10.0.1.0/24"
      start       = "10.0.1.200"
      end         = "10.0.1.254"
      router      = "10.0.1.1"
      zone        = gravity_dns_zone.ripplefcl_com.id
    }
    lan       = {
      subnet_cidr = "10.0.3.0/24"
      start       = "10.0.3.100"
      end         = "10.0.3.254"
      router      = "10.0.3.1"
      zone        = gravity_dns_zone.ripplefcl_com.id
    }
    wlan       = {
      subnet_cidr = "10.0.5.0/24"
      start       = "10.0.5.100"
      end         = "10.0.5.254"
      router      = "10.0.5.1"
      zone        = gravity_dns_zone.ripplefcl_com.id
    }
    vm_network       = {
      subnet_cidr = "10.0.7.0/24"
      start       = "10.0.7.200"
      end         = "10.0.7.254"
      router      = "10.0.7.1"
      zone        = gravity_dns_zone.ripplefcl_com.id
    }
  })
}

resource "gravity_dhcp_scope" "dns_scope" {
  for_each = local.dhcp_scopes

  name = each.key

  subnet_cidr = each.value.subnet_cidr

  ipam = {
    type        = "internal"
    range_start = each.value.start
    range_end = each.value.end

  }

  # Set DHCP Options
  option {
    tag_name = "router"
    value    = each.value.router
  }

  # option {
  #   tag_name = "name_server"
  #   value64 = [base64encode("10.0.7.10"), base64encode("10.0.7.11")]
  # }

  # DNS Options
  dns {
    # When `zone` is also configured in gravity, DNS records are created automatically
    zone                 = gravity_dns_zone.ripplefcl_com.id
    add_zone_in_hostname = true
  }
}
