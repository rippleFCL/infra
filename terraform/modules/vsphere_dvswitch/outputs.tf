output "port_groups"{
    value = {for pg in vsphere_distributed_port_group.pg: pg.name => pg}
}