output "ip" {
  value = "${aws_eip.ip_publico.public_ip}"
}