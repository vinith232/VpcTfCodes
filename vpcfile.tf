# Create New VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Pub Subnet
resource "aws_subnet" "pub-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "public-subnettt"
  }
}

# Create Prvt Subnet
resource "aws_subnet" "pvt-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-subnett"
  }
}
# Routing Table For Public
resource "aws_route_table" "pub-route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-route"
  }
  # depends_on = [aws_internet_gateway.igw]
}

# Crete Route Table Association For Public
resource "aws_route_table_association" "pub-route-ass" {
  subnet_id      = aws_subnet.pub-subnet.id
  route_table_id = aws_route_table.pub-route.id
}
# Routing Table For Private
resource "aws_route_table" "pvt-route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
     gateway_id = aws_nat_gateway.ngw.id
    #vpc_peering_connection_id = aws_vpc_peering_connection.mypeer.id
  }
  tags = {
    Name = "private-route"
  }
}
#Create Route Table Association For Private
resource "aws_route_table_association" "prt-route-ass" {
  subnet_id      = aws_subnet.pvt-subnet.id
  route_table_id = aws_route_table.pvt-route.id
}
# Pub Sg
resource "aws_security_group" "pub-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public-sg"
  }
}
# Pvt Sg
resource "aws_security_group" "pvt-sg" {
  name        = "private-sg"
  description = "Allow TLS inbound traffic for private sg"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "prvt-sgq"
  }
}


# Ec2 Pub
resource "aws_instance" "public-ec2" {
  ami    = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.small"
  subnet_id     = aws_subnet.pub-subnet.id
  #key_name   = "ajith22"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.pub-sg.id]
  tags = {
    Name = "Public-vgs"
  }
}

# EC2 Prvt
resource "aws_instance" "private-ec2" {
  ami    = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.small"
  subnet_id     = aws_subnet.pvt-subnet.id
  #key_name   = "ajith22"
  vpc_security_group_ids = [aws_security_group.pvt-sg.id]
  tags = {
    Name = "Private-vgs"
  }
}

# Internet Gate Way
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myigw"
  }
}
 # EIP # Must Read Before Delete This
 resource "aws_eip" "myeip" {
   vpc   =  true
 }
 #Nat Gate Way
 resource "aws_nat_gateway" "ngw" {
   allocation_id = aws_eip.myeip.id
   subnet_id     = aws_subnet.pub-subnet.id
  
   tags = {
     Name = "natgw"
   }
 }

# Create 2nd VPC For Peering Connection
# resource "aws_vpc" "peervpc" {
#   cidr_block = "11.0.0.0/16"
# }

# Create Peering Subnet
# resource "aws_subnet" "peer-subnet" {
#   vpc_id     = aws_vpc.peervpc.id
#   cidr_block = "11.0.1.0/24"
#   availability_zone = "ap-south-1a"

#   tags = {
#     Name = "Peering-subnet"
#   }
# }

# Route Table For Peering Connection
# resource "aws_route_table" "peer-route" {
#   vpc_id = aws_vpc.peervpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     vpc_peering_connection_id = aws_vpc_peering_connection.mypeer.id
    
#   }
#   tags = {
#     Name = "Peer-routesss"
#   }
#   # depends_on = [aws_internet_gateway.igw]
# }

# # Route Table Association for Peering Connection
# resource "aws_route_table_association" "peer-route-ass" {
#   subnet_id      = aws_subnet.peer-subnet.id
#   route_table_id = aws_route_table.peer-route.id
# }

# Create Peering Connection Sec-Group
# resource "aws_security_group" "peer-sg" {
#   name        = "peer-sg"
#   description = "Allow TLS inbound traffic for private sg"
#   vpc_id      = aws_vpc.peervpc.id

#   ingress {
#     description      = "TLS from VPC"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     # ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "peering-sg"
#   }
# }
# Create EC2 For Peering Connection
# resource "aws_instance" "peering-ec2" {
#   ami    = "ami-0ad21ae1d0696ad58"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.peer-subnet.id
#   key_name   = "Mumbai-Linux"
#   vpc_security_group_ids = [aws_security_group.peer-sg.id]
#   tags = {
#     Name = "peer-vgs"
#   }
# }
# Create Peer Connection
# resource "aws_vpc_peering_connection" "mypeer" {
#   # peer_owner_id = 7673-9786-8500
#   peer_vpc_id   = aws_vpc.peervpc.id
#   vpc_id        = aws_vpc.myvpc.id
#   auto_accept   = true

#   tags = {
#     Name = "VPC Peering between myvpc and peervpc"
#   }
# }

# Create Peering Connection For Different Region
# resource "aws_vpc" "diffvpc" {
#   # provider   = "aws.region2"
#   cidr_block = "12.0.0.0/16"
# }

# Create Peering Subnet For Different Region
# resource "aws_subnet" "diff-subnet" {
#   vpc_id     = aws_vpc.diffvpc.id
#   cidr_block = "12.0.1.0/24"
#   availability_zone = "ap-south-1a"

#   tags = {
#     Name = "Peering-subnet"
#   }
# }

# #Route Table For Peering Connection for Different Region
# resource "aws_route_table" "diff-route" {
#   vpc_id = aws_vpc.diffvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     vpc_peering_connection_id = aws_vpc_peering_connection.diffpeer.id
#   }
#   tags = {
#     Name = "Diff-route"
#   }
#   # depends_on = [aws_internet_gateway.igw]
# }

# # Route Table Association for Peering Connection for different region
# resource "aws_route_table_association" "diff-route-ass" {
#   subnet_id      = aws_subnet.diff-subnet.id
#   route_table_id = aws_route_table.diff-route.id
# }

# # Create Peering Connection Sec-Group dor different region
# resource "aws_security_group" "diff-sg" {
#   name        = "diff-sg"
#   description = "Allow TLS inbound traffic for private sg"
#   vpc_id      = aws_vpc.diffvpc.id

#   ingress {
#     description      = "TLS from VPC"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     # ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "diff-sg"
#   }
# }
# # Create EC2 For Peering Connection for different region
# resource "aws_instance" "diff-ec2" {
#   ami    = "ami-0ad21ae1d0696ad58"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.diff-subnet.id
#   key_name   = "Mumbai-Linux"
#   vpc_security_group_ids = [aws_security_group.diff-sg.id]
#   tags = {
#     Name = "diff-vgs"
#   }
# }

# # Create Peering Connection For Different Region
# resource "aws_vpc_peering_connection" "diffpeer" {
#   # peer_owner_id = 7673-9786-8500
#   # provider          = "aws.region2"
#   peer_vpc_id   = aws_vpc.diffvpc.id
#   vpc_id        = aws_vpc.peervpc.id
#   auto_accept   = true
#   # peer_region   = "ap-south-1"
#   # peer_region   = "ap-southeast-2"

#   tags = {
#     Name = "VPC Peering between Peer.vpc and Diff.vpc"
#   }
# }

