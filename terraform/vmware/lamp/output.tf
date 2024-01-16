output "ip" {
   value = "${vsphere_virtual_machine.lamp01.*.default_ip_address}"
}
