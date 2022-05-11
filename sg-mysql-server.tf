resource "aws_security_group" "sg-mysql" {
  name        = "MySQL-Server-SG"
  description = "Allowing the MySQL traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.main_vpc_cidr}"]
  }
  
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
    Name = "MySQL Server"
    Project = "Test"
  }
}