terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_instance" "Sss1" {
  ami           = "ami-0a72af05d27b49ccb" 
  instance_type = "t2.micro"
  user_data = <<EOF
#!/bin/bash 
# This installs the CodeDeploy agent and its prerequisites on Ubuntu 22.04.  
sudo apt-get update 
sudo apt-get install ruby-full ruby-webrick wget -y 
cd /tmp 
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/releases/codedeploy-agent_1.3.2-1902_all.deb 
mkdir codedeploy-agent_1.3.2-1902_ubuntu22 
dpkg-deb -R codedeploy-agent_1.3.2-1902_all.deb codedeploy-agent_1.3.2-1902_ubuntu22 
sed 's/Depends:.*/Depends:ruby3.0/' -i ./codedeploy-agent_1.3.2-1902_ubuntu22/DEBIAN/control 
dpkg-deb -b codedeploy-agent_1.3.2-1902_ubuntu22/ 
sudo dpkg -i codedeploy-agent_1.3.2-1902_ubuntu22.deb 
systemctl list-units --type=service | grep codedeploy 
sudo service codedeploy-agent status
EOF

  tags = {
    Name = "server2"
  }
}
