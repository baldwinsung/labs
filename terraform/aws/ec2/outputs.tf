output "private_ip" {
   value = "${aws_instance.server01.private_ip}"
}

output "public_ip" {
   value = "${aws_instance.server01.public_ip}"
}

output "public_dns" {
   value = "${aws_instance.server01.public_dns}"
}
