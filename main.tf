terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = var.Access_key
  secret_key = var.secret_key
}

# Create Infrastructure VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr_block
}

# Create Web Public Subnet
resource "aws_subnet" "web-subnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.cidr_block_subnet
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "Infrasture IGW"
  }
}

# Create Web layer route table
resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Infrastrure Web route table"
  }
}

# Create Web Subnet association with Web route table
resource "aws_route_table_association" "art" {
  subnet_id      = aws_subnet.web-subnet.id
  route_table_id = aws_route_table.web-rt.id
}

#Create EC2 Instance
resource "aws_instance" "webserver" {
  ami                    = "ami-0d5eff06f840b45e9"
  instance_type          = var.instance_type
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.server-sg.id]
  subnet_id              = aws_subnet.web-subnet.id
  user_data              = file("installngnix.sh")
  key_name               = "aws_keys"

  tags = {
    Name = "ec2_iac_server"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("./aws_key/aws_keys")
    timeout     = "4m"
  }

  #   provisioner "file" {
  #     source      = "conf/myapp.conf"
  #     destination = "C:/App/myapp.conf"

  #     connection {
  #       type     = "winrm"
  #       user     = "Administrator"
  #       password = var.admin_password
  #       host     = var.host
  #     }
  #   }
}

# Create Web Security Group
resource "aws_security_group" "server-sg" {
  name        = "Web-SG"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_keys"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoR+iganH8pjs+GG5t0oNKQ4Bv/2inU7I6gB9kyhQpgekLO7PHW6JrOqTUob7P1DXF1r20luL2VQHV4aaZaOfxj2PSn/uVSm6J/V29hw1OnLmfSpiw70Cavxj7UdyUe+VrGMSiLbF/vNcotLl2Dh3f5gtSdOXjpExE/phSZh/Y20jiRHVPI9DqEpw5A14ERsahRXHQg6tYGR4vFWd0KJHBxpXt/zc14w/pnP585OBb51Phfx8EnAYbk85PcYwKD52cRpw/vK/i0S/doK4dl0FacaxYs3ZV4m776IqQcm3Z/qI8SH9GR/CtAjA2SM66OD6sCzEYmu1LsAN+FkogKCyL alaonr@MacBooks-MacBook-Pro.local"
}

output "server_details" {
  value = aws_instance.webserver.arn
}



