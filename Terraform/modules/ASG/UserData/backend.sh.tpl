#!/bin/bash
# Update system packages
sudo apt update -y

# Install necessary packages
sudo apt install -y curl git awscli

# Install Node.js 18.x (Amazon Linux 2023 uses apt instead of apt)
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
sudo apt install -y nodejs

# Set the AWS region environment variable
export AWS_DEFAULT_REGION="us-east-1"

# Manually assign MySQL credentials (adjust accordingly)
export RDS_HOSTNAME=${RDS_HOSTNAME}
export RDS_USERNAME=${RDS_USERNAME}
export RDS_PASSWORD=${RDS_PASSWORD}
RDS_PORT="3306"

# Clone the repository
cd /home/ubuntu
git clone https://github.com/SeifOssama/AWS-3-Tier-Web-Architecture.git

# Change directory to the backend folder
cd AWS-3-Tier-Web-Architecture/Backend

# Install dependencies
sudo npm install

# Create the .env file with MySQL connection details
echo "RDS_HOSTNAME=$RDS_HOSTNAME" > .env
echo "RDS_USERNAME=$RDS_USERNAME" >> .env
echo "RDS_PASSWORD=$RDS_PASSWORD" >> .env
echo "RDS_PORT=$RDS_PORT" >> .env

# Set correct file ownership
sudo chown ubuntu:ubuntu .env

# Run the backend server in the background and log output to a file
nohup npm start >> /home/ubuntu/app.log 2>&1 &
