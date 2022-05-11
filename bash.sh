#!/bin/bash
echo ""
echo -e "\e[1;31mPlease input the values prompting\e[0m"
echo ""
echo ""
echo "Enter the Region (For eg: ap-south-1, us-west-2 etc...) "
read region
echo "Enter the VPC Network (Make sure you include the Range with Subnet mask like 10.1.0.0/16)"
read vpc  #reading the VPC network with Mask

echo -e "\e[1;31m===========================================================================\e[0m"
echo -e "\e[1;31mWhile Entering the Subnets, make sure you are adding the Subnet mask\e[0m"
echo -e "\e[1;31m===========================================================================\e[0m"


echo "Enter the Public subnet1:"
read pusub1
echo "Enter the Private subnet1"
read prsub1

echo ""
echo "Enter the Bastion Host instance type"
read bast_in_type

echo ""
echo "Enter the MySQL Database server instance type"
read mysql_in_type

echo ""
echo "Enter the Jenkins Host instance type"
read jenkins_in_type

echo ""
echo "Enter the Webserver Host instance type"
read web_in_type

echo ""
echo "Enter the SSH Key pair name (make sure you have created one using the AWS Console)"
read key

echo "MySQL instance is using the same key pair for Bastion host"
echo ""

#Configuring the tfvars
> terraform.tfvars
echo "main_vpc_cidr =  \"$vpc\" " > terraform.tfvars
echo " public_subnet1 = \"$pusub1\" " >> terraform.tfvars
echo " private_subnet1 =  \"$prsub1\" " >> terraform.tfvars
echo "region = \"$region\"" >> terraform.tfvars
echo "zone1 = \"${region}a\"" >> terraform.tfvars
echo "zone2 = \"${region}b\"" >> terraform.tfvars
echo "bast_inst_type = \"$bast_in_type\"" >> terraform.tfvars
echo "mysql_inst_type = \"$mysql_in_type\"" >> terraform.tfvars
echo "jenkins_inst_type = \"$jenkins_in_type\"" >> terraform.tfvars
echo "web_inst_type = \"$web_in_type\"" >> terraform.tfvars
echo "key =  \"$key\"" >> terraform.tfvars

#Running terraform operations
echo "Running terraform init"
terraform init
echo "Running terraform Plan"
terraform plan -out "tfplan"

echo -e "\e[1;31m===========================================================================\e[0m"
echo -e "\e[1;31mPlease verify the plan. You can run the \"terraform apply command\" \e[0m"
echo -e "\e[1;31m===========================================================================\e[0m"

#echo "applying terraform"
#terraform apply