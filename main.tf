provider "aws" {
    region = "eu-west-1"
}

resource "aws_vpc" "mytest-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

#Create one or several test instances
#===============================
resource "aws_instance" "test_server" {
 count                       = var.instance_count
 ami                         = var.image_name
 instance_type               = var.instance_type
 key_name                    = "terraform-study-key"
 associate_public_ip_address = true
 vpc_security_group_ids      = [aws_security_group.test-sg.id]
 subnet_id                   = aws_subnet.myapp-subnet-1.id

# user_data = file("entry-script.sh")

  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}

resource "aws_security_group" "test-sg" {
    vpc_id = aws_vpc.mytest-vpc.id
    name = "test-sg"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
      "Name" = "test-sg"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.mytest-vpc.id
    cidr_block = var.subnet_cidr_block
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "mytest-igw" {
    vpc_id = aws_vpc.mytest-vpc.id
    tags = {
      Name = "${var.env_prefix}-igw"
    }
}

resource "aws_route_table" "myapp-route-table" {
   vpc_id = aws_vpc.mytest-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.mytest-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}

resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}