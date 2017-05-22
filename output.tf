output "configuration_endpoint_address" {
  value = "${aws_elasticache_replication_group.default.configuration_endpoint_address}"
}

output "ssh_host" {
  value = "${aws_instance.ssh_host.public_ip}"
}
