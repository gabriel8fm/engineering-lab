provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_s3_bucket" "bucket-iac-terraform" {
  bucket = "bucket-iac-terraform"
  acl = "private"
}

resource "aws_security_group" "fw-terraform" {
  name = "fw-terraform"
  description = "firewall terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "ip_publico" {
  instance = "${aws_instance.teste_terraform.id}"
}

resource "aws_key_pair" "acesso_ssh" {
  key_name = "gmiranda_macbookpro"
  public_key = "xxxxxxx"
}

resource "aws_instance" "teste_terraform" {
  ami = "ami-0782e9ee97725263d"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.acesso_ssh.key_name}"
  security_groups = ["${aws_security_group.fw-terraform.name}"]

  depends_on = ["aws_s3_bucket.bucket-iac-terraform"]

  provisioner "file" {
    source = "install_nginx.sh"
    destination = "/tmp/install_nginx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_nginx.sh",
      "/tmp/install_nginx.sh",
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("son_terraform_pvt")}"
    agent = "false"
  }
}
