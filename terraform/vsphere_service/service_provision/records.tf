locals {
  dns_records = tolist([
    {
      hostname = "network-services-01"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "10.0.7.10"
      type     = "A"
    },
    {
      hostname = "storage-ssd-nas"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "10.0.1.31"
      type     = "A"
    },
    {
      hostname = "storage-hdd-nas"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "10.0.1.32"
      type     = "A"
    },
    {
      hostname = "unifi"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "network-services-02"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "10.0.7.10"
      type     = "A"
    },
    {
      hostname = "docker-01"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "10.0.7.21"
      type     = "A"
    },
    {
      hostname = "docker-gpu-01"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "10.0.7.20"
      type     = "A"
    },
    {
      hostname = "proxy-internal-01"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "10.0.7.15"
      type     = "A"
    },
    {
      hostname = "proxy-external-01"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "10.0.7.16"
      type     = "A"
    },
    {
      hostname = "overseerr"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "sab"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "radarr"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "sonarr"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "plex"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "tautulli"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "wakapi"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "languagetool"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "wan_ping"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "prom"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "romm"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "grafana"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "gravity-01"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "network-services-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "gravity-02"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "network-services-02.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "gravity"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "bws"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
    {
      hostname = "immich"
      zone     = gravity_dns_zone.ripplefcl_com.id
      data     = "proxy-internal-01.ripplefcl.com."
      type     = "CNAME"
    },
  ])
}

resource "gravity_dns_record" "records" {
  for_each = { for idx, record in local.dns_records : record.hostname => record }
  zone     = each.value.zone
  hostname = each.value.hostname
  uid      = index(local.dns_records, each.value) + 1
  data     = each.value.data
  type     = each.value.type
}
