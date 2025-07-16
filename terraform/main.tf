# ---------------------
# Provider & variables
# ---------------------
provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

# ---------------------
# Key pair
# ---------------------
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("/var/lib/jenkins/.ssh/terraform-key.pub")
}

# ---------------------
# Security‑group
# ---------------------
resource "aws_security_group" "abc_sg" {
  name        = "abc_sg"
  description = "SSH + HTTP(S) + Portainer"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Portainer"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------
# EC2 instance
# ---------------------
resource "aws_instance" "abc" {
  ami           = "ami-053b0d53c279acc90"      # Ubuntu 22.04 LTS
  instance_type = "t3a.medium"                 # 2 vCPU / 4 GiB RAM
  key_name      = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.abc_sg.id]

  # pour éviter la facturation des CPU credits si le CPU tourne peu
  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size = 60       # + marge images/logs
    volume_type = "gp3"    # moins cher & + performant que gp2
  }

  tags = {
    Name = "abc"
    Owner = "DevOps"
    Environment = "prod"
  }
}

# ---------------------
# Outputs
# ---------------------
output "instance_public_ip" {
  value = aws_instance.abc.public_ip
}
