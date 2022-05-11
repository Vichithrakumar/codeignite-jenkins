
resource "aws_instance" "instance4" {
  ami                         = "ami-05ba3a39a75be1ec4"
  instance_type               = var.web_inst_type
  key_name                    = var.key
  vpc_security_group_ids      = [aws_security_group.sg-webserver.id]
  subnet_id                   = aws_subnet.publicsubnet1.id
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/bash -xe

install_dir="/var/www/html/codeigniter"

apt -y update 
apt -y upgrade
apt -y install apache2
apt -y install php php-cli php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-intl
apt -y install mysql-client

wget https://github.com/codeigniter4/CodeIgniter4/archive/refs/tags/v4.1.8.tar.gz

tar -xzf v4.1.8.tar.gz

mkdir /var/www/html/codeigniter
cp -pr CodeIgniter4-4.1.8/* /var/www/html/codeigniter
touch /etc/apache2/sites-available/codeigniter.conf

chown www-data: /var/www/html/codeigniter -R
mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf_old

cat > /etc/apache2/sites-available/codeigniter.conf << EOD
<VirtualHost *:80>
    ServerAdmin webmaster@example.com
    DocumentRoot /var/www/html/codeigniter/public
    ErrorLog /var/log/apache2/codeigniter-error_log
    CustomLog /var/log/apache2/codeigniter-access_log combined
    <Directory /var/www/html/public>
	Require all granted
        AllowOverride All
        Options +Indexes
    </Directory>
</VirtualHost>
EOD

a2ensite $site/codeigniter.conf

systemctl reload apache2

EOF

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "Test Web Server"
    Project = "Test"
  }
}