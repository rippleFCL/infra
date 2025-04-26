resource "vsphere_tag_category" "environ" {
  name        = "vm-environ-prod"
  cardinality = "MULTIPLE"
  description = "current environ"

  associable_types = [
    "VirtualMachine",
  ]
}

resource "vsphere_tag" "internal-services" {
  name        = "internal-services"
  category_id = vsphere_tag_category.environ.id
  description = "internal services"
}

resource "vsphere_tag" "external-services" {
  name        = "external-services"
  category_id = vsphere_tag_category.environ.id
  description = "external services"
}

resource "vsphere_tag" "networking-services" {
  name        = "networking-services"
  category_id = vsphere_tag_category.environ.id
  description = "networking services"
}

resource "vsphere_tag" "debian" {
  name        = "debian"
  category_id = vsphere_tag_category.environ.id
  description = "machines running debian"
}




resource "vsphere_tag" "docker-host" {
  name        = "docker-hosts"
  category_id = vsphere_tag_category.environ.id
  description = "machines running debian"
}

resource "vsphere_tag" "proxy-hosts" {
  name        = "proxy-hosts"
  category_id = vsphere_tag_category.environ.id
  description = "machines running debian"
}


resource "vsphere_tag" "docker-gpu-host" {
  name        = "docker-gpu-hosts"
  category_id = vsphere_tag_category.environ.id
  description = "machines running debian"
}
