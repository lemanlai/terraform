provider "aws" {
  region="us-east-1"
  version = "~>3.0"
}

resource "aws_vpc" "leman_test" {
  cidr_block = "10.11.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "leman-test-terraform-20210420"
  }
}

resource "aws_internet_gateway" "leman_test_gateway" {
  vpc_id = aws_vpc.leman_test.id
  tags = {
    Name = "leman_test_gateway"
  }
}

resource "aws_subnet" "leman_test_subnet" {
  vpc_id = aws_vpc.leman_test.id
  cidr_block = "10.11.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "leman_test_subnet"
  }
}

#resource "aws_route_table" "leman_test_public_route" {
#  vpc_id = "aws_vpc.leman_test.id"
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = "aws_internet_gateway.leman_test.gateway"
#  }
#}

#resource "aws_route_table" "leman_test_private_route" {
#  vpc_id = "aws_vpc.leman_test.id"
#}

#resource "aws_route_table_association" "leman_subnet_to_route" {
#  subnet_id = "aws_subnet.leman_test.subnet.id"
#  route_table_id = "aws_route_table.leman_test_public_route"
#}


resource "aws_instance" "leman_ec2" {
  ami = "ami-0022c769"
  instance_type = "c1.medium"

#  key_name = "dev"
  subnet_id = aws_subnet.leman_test_subnet.id
  private_ip = "10.11.1.101"
  tags = {
    Name = "leman_ec2"
  }
}
