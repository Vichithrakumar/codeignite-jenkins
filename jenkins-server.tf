resource "aws_instance" "instance3" {
  ami                         = "ami-05ba3a39a75be1ec4"
  instance_type               = var.jenkins_inst_type
  key_name                    = var.key
  vpc_security_group_ids      = [aws_security_group.sg-jenkins.id]
  subnet_id                   = aws_subnet.publicsubnet1.id
  associate_public_ip_address = true
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

mkdir /root/jenkins
mkdir /root/jenkins/jenkins_home

cat > /root/jenkins/docker-compose.yaml << EOD
version: '3'
services:
  jenkins:
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8080:8080
      - 50000:50000
    container_name: jenkins
    volumes:
      - /root/jenkins/jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
EOD

docker-compose -f /root/jenkins/docker-compose.yaml up -d

EOF



  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "Test Jenkins"
    Project = "Test"
  }
}