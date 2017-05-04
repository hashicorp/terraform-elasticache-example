output "cluster_address" {
  value = "${module.elasticache.cluster_address}"
}

output "configuration_endpoint" {
  value = "${module.elasticache.configuration_endpoint}"
}

output "cache_nodes" {
  value = ["${module.elasticache.cache_nodes}"]
}

output "ssh_host" {
  value = "${aws_instance.ssh_host.public_ip}"
}

output "vpc_id" {
  value = "${module.vpc.id}"
}

output "vpc_subnets" {
  value = ["${module.vpc.subnets}"]
}

output "vpc_subnet_names" {
  value = ["${module.vpc.subnet_names}"]
}
