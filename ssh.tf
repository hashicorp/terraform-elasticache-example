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

  subnet_id              = "${element(aws_subnet.default.*.id,0)}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  user_data              = "${data.template_file.startup.rendered}"

  tags = "${map(
    "Name", "${var.namespace}-ssh-host",
  )}"
}
