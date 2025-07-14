provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "abc" {
  ami           = "ami-053b0d53c279acc90"  # Ubuntu 22.04 LTS dans us-east-1
  instance_type = "m5.2xlarge"             # 8 vCPU, 32 Go RAM
  key_name      = aws_key_pair.terraform_key.key_name  
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "abc"
  }

  root_block_device {
    volume_size = 32
    volume_type = "gp2"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access from anywhere"
  vpc_id      = data.aws_vpc.default.id  # On suppose que tu veux utiliser le VPC par défaut

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("/var/lib/jenkins/.ssh/terraform-key.pub")
}


output "instance_ip" {
  value = aws_instance.abc.public_ip
}


