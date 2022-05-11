#Create the VPC
 resource "aws_vpc" "Main" {                # Creating VPC here
   cidr_block       = var.main_vpc_cidr     # Defining the CIDR block 
   instance_tenancy = "default"
   enable_dns_hostnames = true
   enable_dns_support   = true
   tags = {
     Name = "Test VPC"
     Project = "Test"
   }
 }
 #Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "IGW1" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.Main.id
    tags = {
    Name = "Test IG"
    Project = "Test"
  }              # vpc_id will be generated after we create VPC
 }


 #Create a Public Subnets.
 resource "aws_subnet" "publicsubnet1" {    # Creating Public Subnets
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.public_subnet1}"        # CIDR block of public subnets
   availability_zone= "${var.zone1}"
   tags = {
    Name = "Test Public Subnet"
    Project = "Test"
  }
 }

 
 #Create a Private Subnet                   # Creating Private Subnets
 resource "aws_subnet" "privatesubnet1" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.private_subnet1}"          # CIDR block of private subnets
   availability_zone= "${var.zone1}"
   tags = {
    Name = "Test Private Subnet"
    Project = "Test"
  }
 }


 #Route table for Public Subnet's
 resource "aws_route_table" "PublicRT1" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.Main.id
         route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW1.id
    }
    tags = {
    Name = "Test-publicroute"
    Project = "Test"
  }
 }

 #Route table for Private Subnet's
 resource "aws_route_table" "PrivateRT1" {    # Creating RT for Private Subnet
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = aws_nat_gateway.NATgw1.id
   }
    tags = {
    Name = "Test-privateroute"
    Project = "Test"
  }
 }


 #Route table Association with Public Subnet's
 resource "aws_route_table_association" "PublicRTassociation1" {
    subnet_id = aws_subnet.publicsubnet1.id
    route_table_id = aws_route_table.PublicRT1.id
 }

 #Route table Association with Private Subnet's
 resource "aws_route_table_association" "PrivateRTassociation1" {
    subnet_id = aws_subnet.privatesubnet1.id
    route_table_id = aws_route_table.PrivateRT1.id
 }


 resource "aws_eip" "nateIP1" {
   vpc   = true
   tags = {
    Name = "Test-NatIP"
    Project = "Test"
   }
 }


 #Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "NATgw1" {
   allocation_id = aws_eip.nateIP1.id
   subnet_id = aws_subnet.publicsubnet1.id
   tags = {
    Name = "Test-NatGateway"
    Project = "Test"
   }
 }
