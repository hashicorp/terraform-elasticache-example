variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "namespace" {
  description = "Default namespace"
  default     = "elasticache-tutorial"
}

variable "cluster_id" {
  description = "Id to assign the new cluster"
  default     = "redis-cluster"
}

variable "public_key_path" {
  description = "Path to public key for ssh access"
  default     = "~/.ssh/rmx-test.pub"
}

variable "node_groups" {
  description = "Number of nodes groups to create in the cluster"
  default     = 3
}

variable "node_type" {
  description = "Type of Elasticache node to use"
  default     = "cache.t2.micro"
}

variable "port" {
  description = "Default port to be used by Redis"
  default     = 6379
}
