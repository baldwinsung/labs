output "ip" {
   value = "${vsphere_virtual_machine.k8s01.*.default_ip_address}"
}
