resource "aws_security_group" "sg-bastionhost" {
  name        = "Bastion-Host-SG"
  description = "Allowing the SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.Main.id
  tags = {
    Name = "Bastion-Host"
    Project = "Test"
  }
}