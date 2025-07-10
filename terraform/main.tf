provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "abc" {
  ami           = "ami-053b0d53c279acc90"  # Ubuntu 22.04 LTS dans us-east-1
  instance_type = "m5.2xlarge"             # 8 vCPU, 32 Go RAM

  tags = {
    Name = "abc"
  }

  root_block_device {
    volume_size = 32
    volume_type = "gp2"
  }
}

