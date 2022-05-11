# codeignite-jenkins

This project is a combination of terraform and bash to create Infrastructure in AWS.

It will create,

    1. VPC
    2. Private Subnet
    3. Public Subnet
    4. Bastion Host Server (Docker pre-installed)
    5. Jenkins Server (Jenkins running as docker container in EC2)
    6. MySQL Server (Running as Docker container in EC2)
    7. Webserver (Code Ignitor pre-installed)

The Docker compose files will create automatically and run automatically. 

# How to run the script

** git clone https://github.com/Vichithrakumar/codeignite-jenkins.git ; cd codeignite-jenkins ; bash bash.sh **