resource "vsphere_tag_category" "environ" {
  name        = "networking-environ-prod"
  cardinality = "MULTIPLE"
  description = "current environ"

  associable_types = [
    "VirtualMachine",
  ]
}

resource "vsphere_tag" "opnsense" {
  name        = "opnsense"
  category_id = vsphere_tag_category.environ.id
  description = "machines running opnsense"
}

resource "vsphere_tag" "gw-fw-cu" {
  name        = "gw-fw-cu"
  category_id = vsphere_tag_category.environ.id
  description = "the internal fw cluster"
}


resource "vsphere_tag" "int-fw-cu" {
  name        = "core-fw-cu"
  category_id = vsphere_tag_category.environ.id
  description = "the internal fw cluster"
}
