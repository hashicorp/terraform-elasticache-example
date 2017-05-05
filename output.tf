output "cluster_address" {
  value = "${aws_elasticache_cluster.default.cluster_address}"
}

output "configuration_endpoint" {
  value = "${aws_elasticache_cluster.default.configuration_endpoint}"
}

output "cache_nodes" {
  value = ["${aws_elasticache_cluster.default.cache_nodes}"]
}

output "ssh_host" {
  value = "${aws_instance.ssh_host.public_ip}"
}
