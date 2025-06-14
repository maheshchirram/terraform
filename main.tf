
# create vpc

resource "aws_vpc" "prod_vpc"{
  cidr_block       = var.vpc_cidr

  tags = {
    Name = "mini_vpc"
  }
}

# create an internet gatway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "internet-gw"
  }
}

# creating custom routr table 

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  
  }

  tags = {
    Name = "mini_route"
  }
}

# aws creating submnet

resource "aws_subnet" "sb" {
  vpc_id     = aws_vpc.prod_vpc.id
  cidr_block = var.sub_cidr_block

  tags = {
    Name = "mini_sub"
  }
}

# associate routetables with the public subnet

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.sb.id
  route_table_id = aws_route_table.rt.id

}

# creating security group


resource "aws_security_group" "prod_sg"{
 
 vpc_id  = aws_vpc.prod_vpc.id

# inbound rule

ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world; restrict as needed
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

# outbound rules (allowing all traffic)

egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod_sg"
  }
}

#creating  netork interface 

resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.sb.id
  private_ips     = [var.nic]
  security_groups = [aws_security_group.prod_sg.id]

}

# assigning elastic ip 

resource "aws_eip" "prod_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.test.id
  associate_with_private_ip = var.aws_eip

tags = {
    Name = "mini_eip"
  }

 # creating ec2-instnce 

}

resource "aws_instance" "prod" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    user_data = "${file("userdata.sh")}"

network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }
tags = {
  Name = "mini_proj"
}
  
}

output "instance_ip_addr" {
  value = aws_instance.prod.public_ip
}

