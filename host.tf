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

resource "aws_key_pair" "ssh_key" {
  key_name   = "rmx-test"
  public_key = file(var.public_key_path)
}

data "template_file" "install_tools" {
  template = file("${path.module}/templates/configure.sh.tpl")
}

resource "aws_instance" "ssh_host" {
  ami           = data.aws_ami.ubuntu-1604.id
  instance_type = "t2.nano"
  key_name      = aws_key_pair.ssh_key.id

  subnet_id              = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.default.id]

  tags = map(
    "Name", "${var.namespace}-ssh-host",
  )
}
