resource "vsphere_tag_category" "environ" {
  name        = "storage-environ-prod"
  cardinality = "MULTIPLE"
  description = "current environ"

  associable_types = [
    "VirtualMachine",
  ]
}

resource "vsphere_tag" "debian" {
  name        = "debian"
  category_id = vsphere_tag_category.environ.id
  description = "machines running debian"
}

resource "vsphere_tag" "nas" {
  name        = "nas"
  category_id = vsphere_tag_category.environ.id
  description = "vm nas"
}
