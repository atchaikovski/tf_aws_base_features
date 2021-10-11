###

resource "aws_vpc" "Main" {                # Creating VPC 
   cidr_block       = var.main_vpc_cidr     # CIDR block use var.cidr 
   instance_tenancy = "default"
   tags = {
     Name = "learning VPC"
   }
 }

 resource "aws_internet_gateway" "IGW" {    # Creating IGW
    vpc_id =  aws_vpc.Main.id               # vpc_id generated later
    tags = {
      Name = "Learning VPC (IGW)"
    }
 }

 resource "aws_subnet" "publicsubnets" {   
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.public_subnets}"       # CIDR block for public subnet
   tags = {
      Name = "Learning VPC (public subnet)"
    }
 }

 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.private_subnets}"          # CIDR block of private subnet
   tags = {
      Name = "Learning VPC (private subnet)"
    }
 }

 resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.Main.id
         route {
    cidr_block = "0.0.0.0/0"               
    gateway_id = aws_internet_gateway.IGW.id
     }
 }

 resource "aws_route_table" "PrivateRT" {    # Creating RT for Private Subnet
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }

 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }
 
 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }

 resource "aws_eip" "nateIP" {
   vpc   = true
 }
 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
   tags = {
     Name = "Learning VPC NAT GW"
   }
 }