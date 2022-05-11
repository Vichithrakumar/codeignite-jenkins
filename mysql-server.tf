resource "aws_instance" "instance2" {
  ami                         = "ami-05ba3a39a75be1ec4"
  instance_type               = var.mysql_inst_type
  key_name                    = var.key
  vpc_security_group_ids      = [aws_security_group.sg-mysql.id]
  subnet_id                   = aws_subnet.privatesubnet1.id
  associate_public_ip_address = false
  user_data                   = <<EOF
#!/bin/bash -xe
apt-get update -y
apt-get install apt-transport-https -y
apt-get install ca-certificates -y
apt-get install curl -y
apt-get install gnupg -y
apt-get install lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
	  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y

mkdir /root/mysql
mkdir /root/mysql/db

cat > /root/mysql/docker-compose.yaml << EOD
version: '3'
services:
  db:
    image: mysql:5.7
    privileged: true
    environment:
      MYSQL_DATABASE: 'db'
      # So you don't have to use root, but you can if you like
      MYSQL_USER: 'dbuser'
      # You can use whatever password you like
      MYSQL_PASSWORD: 'Password@321'
      # Password for root access
      MYSQL_ROOT_PASSWORD: 'Password@321'
    ports:
      - 3306:3306
    container_name: mysql
    volumes:
      - /root/mysql/db:/var/lib/mysql
      
EOD

docker-compose -f /root/mysql/docker-compose.yaml up -d

EOF

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "Test MySQL Server"
    Project = "Test"
  }
}