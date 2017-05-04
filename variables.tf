# AWS Specific variables
variable "aws_region" {
  description = "AWS region to create the environment"
}

variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret"
}

variable "namespace" {
  description = "Default namespace"
}

variable "cluster_id" {
  description = "Id to assign the new cluster"
}

variable "public_key_path" {
  description = "Path to public key for ssh access"
  default     = "~/.ssh/id_rsa.pub"
}
