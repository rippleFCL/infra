locals {
  dns_records = tomap({
    network-services-01 = {
      zone = gravity_dns_zone.ripplefcl_com.id
      uid  = "1"
      data = "10.0.7.10"
      type = "A"
    }
    unifi = {
      zone = gravity_dns_zone.ripplefcl_com.id
      uid  = "2"
      data = "network-services-01.ripplefcl.com"
      type = "CNAME"
    }
  })
}

resource "gravity_dns_record" "records" {
  for_each = local.dns_records
  zone     = each.value.zone
  hostname = each.key
  uid      = each.value.uid
  data     = each.value.data
  type     = each.value.type
}
