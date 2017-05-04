module "vpc" {
  source = "github.com/nicholasjackson/terraform-modules/vpc"

  aws_region            = "${var.aws_region}"
  aws_access_key_id     = "${var.aws_access_key_id}"
  aws_secret_access_key = "${var.aws_secret_access_key}"
  namespace             = "${var.namespace}"
}

module "elasticache" {
  source = "github.com/nicholasjackson/terraform-modules/elasticache"

  aws_region            = "${var.aws_region}"
  aws_access_key_id     = "${var.aws_access_key_id}"
  aws_secret_access_key = "${var.aws_secret_access_key}"
  namespace             = "${var.namespace}"
  cluster_id            = "${var.cluster_id}"

  subnets = "${module.vpc.subnets}"
  vpc_id  = "${module.vpc.id}"
}

# Get the list of official Canonical Ubuntu 16.04 AMIs
data "aws_ami" "ubuntu-1604" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "startup" {
  template = "${file("${path.module}/templates/startup.sh.tpl")}"
}

resource "aws_key_pair" "elasticcache" {
  key_name   = "${var.namespace}-elasticcache"
  public_key = "${file("${var.public_key_path}")}"
}

resource "aws_instance" "ssh_host" {
  ami           = "${data.aws_ami.ubuntu-1604.id}"
  instance_type = "t2.nano"
  key_name      = "${aws_key_pair.elasticcache.id}"

  subnet_id       = "${element(module.vpc.subnets,0)}"
  security_groups = ["${module.elasticache.security_group}"]
  user_data       = "${data.template_file.startup.rendered}"

  tags = "${map(
    "Name", "${var.namespace}-ssh-host",
  )}"
}
