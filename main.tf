terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = var.aws_credentials.access_key
  secret_key = var.aws_credentials.secret_key
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "example_sg" {
  name        = "example_sg"
  description = "Security group for example_server"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // Autoriser l'accès depuis n'importe quelle adresse IP
  security_group_id = aws_security_group.example_sg.id
}

resource "aws_security_group_rule" "allow_server_connection" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // Autoriser l'accès depuis n'importe quelle adresse IP
  security_group_id = aws_security_group.example_sg.id
}

resource "aws_security_group_rule" "allow_server_port" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // Autoriser l'accès depuis n'importe quelle adresse IP
  security_group_id = aws_security_group.example_sg.id
}

resource "aws_instance" "example_server" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true
  security_groups = [aws_security_group.example_sg.name]
}

output "domain_name" {
  value = aws_instance.example_server.public_dns
}

resource "null_resource" "ssh_to_docker_container" {
  connection {
    type        = "ssh"
    host        = aws_instance.example_server.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source = "install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "file" {
    source = ".env.local"
    destination = "/tmp/.env.local"
  }

  provisioner "file" {
    source = "nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "file" {
    source = "clone_repo.sh"
    destination = "/tmp/clone_repo.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "cd /tmp",
      "chmod 777 ./install.sh",
      "./install.sh",
      "chmod 777 ./clone_repo.sh",
      "./clone_repo.sh"
    ]
  }

  depends_on = [ aws_instance.example_server ]
}