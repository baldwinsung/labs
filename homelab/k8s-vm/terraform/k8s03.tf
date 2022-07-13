resource "vsphere_virtual_machine" "k8s03" {
  name             = "k8s03"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 2048
  wait_for_guest_net_timeout = 0
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
     network_id   = "${data.vsphere_network.network.id}"
     adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"

  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "k8s03"
        domain    = "some.domain"
      }
      network_interface {
        ipv4_address = "10.0.0.X"
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.0.0.1"
      dns_server_list = ["10.0.0.1"]
    }
  }
}
