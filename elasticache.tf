resource "aws_security_group" "default" {
  name_prefix = "${var.namespace}"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.namespace}-cache-subnet"
  subnet_ids = ["${aws_subnet.default.*.id}"]
}

resource "aws_elasticache_replication_group" "default" {
  replication_group_id          = "${var.cluster_id}"
  replication_group_description = "Redis cluster for Hashicorp ElastiCache example"

  node_type            = "cache.m1.small"
  port                 = 6379
  parameter_group_name = "default.redis3.2.cluster.on"

  subnet_group_name = "${aws_elasticache_subnet_group.default.name}"

  automatic_failover_enabled = true

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = "${var.node_groups}"
  }
}
