#!/bin/bash

# Update and install dependencies
sudo apt update -y
sudo apt install -y nginx git nodejs npm docker.io
sudo npm install -g n
sudo n 18
echo "ay7aga" >> app.log
echo $backend_alb_dns >> app.log

# Configure nginx with proxy for /api to backend ALB
sudo cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm;

    server_name _;

    location / {
        try_files \$uri /index.html;
    }

    location /api/ {
        proxy_pass http://${backend_alb_dns}:5050;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

echo $backend_alb_dns >> app2.log

# Restart nginx to apply config
sudo systemctl reload nginx
sudo systemctl enable docker
# Clone your React app from GitHub
cd /home/ubuntu
git clone https://github.com/SeifOssama/AWS-3-Tier-Web-Architecture.git
cd AWS-3-Tier-Web-Architecture/Frontend

# Install dependencies
sudo npm install

# Build with relative API URL for proxying via Nginx
REACT_APP_API_URL="/api" npm run build

# Copy build files to Nginx
cp -r build/* /var/www/html/

# Restart Nginx after copying files
sudo systemctl restart nginx

