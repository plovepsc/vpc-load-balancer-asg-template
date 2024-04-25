resource "aws_vpc" "levelup_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"


    tags = {
      Name = "levelup_vpc"
    }
  
}



# public subnet of vpc

resource "aws_subnet" "levelupvpc-public-1" {
    vpc_id = aws_vpc.levelup_vpc.id
    cidr_block = "10.0.1.0/24"
   map_public_ip_on_launch = "true" 
    availability_zone = "ap-south-1a"

    tags = {
      Name = "levelupvpc-public-1"
    }
  
}


# public subnet of vpc

resource "aws_subnet" "levelupvpc-public-2" {
    vpc_id = aws_vpc.levelup_vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"

    tags = {
      Name = "levelupvpc-public-2"
    }
  
}



# # private subnet of vpc

# resource "aws_subnet" "levelupvpc-private-1" {
#     vpc_id = aws_vpc.levelup_vpc.id
#     cidr_block = "10.0.3.0/24"
#    map_public_ip_on_launch = "false"
#     availability_zone = "ap-south-1a"

#     tags = {
#       Name = "levelupvpc-private-1"
#     }
  
# }


# # private subnet of vpc

# resource "aws_subnet" "levelupvpc-private-2" {
#     vpc_id = aws_vpc.levelup_vpc.id
#     cidr_block = "10.0.4.0/24"
#    map_public_ip_on_launch = "false"
#     availability_zone = "ap-south-1b"

#     tags = {
#       Name = "levelupvpc-private-2"
#     }
  
# }

# Custom internet gateway 

resource "aws_internet_gateway" "levelup-gw" {
    vpc_id = aws_vpc.levelup_vpc.id
    tags = {
      Name = "levelup-gw"
    }
  
}

# routing table for the custom vpc

resource "aws_route_table" "levelup-public" {
  vpc_id = aws_vpc.levelup_vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup-gw.id 

  }

  tags = {
    Name = "levelupvpc-public-1"
  }
}

resource "aws_route_table_association" "levelup-public-1-a" {
    subnet_id = aws_subnet.levelupvpc-public-1.id
    route_table_id = aws_route_table.levelup-public.id
  
}


resource "aws_route_table_association" "levelup-public-2-a" {
    subnet_id = aws_subnet.levelupvpc-public-2.id
    route_table_id = aws_route_table.levelup-public.id
  
}