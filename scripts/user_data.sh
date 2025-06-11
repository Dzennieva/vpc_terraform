#!/bin/bash
# This script runs on EC2 instance launch via user data

# Update system
sudo apt update -y
sudo apt install -y python3 python3-pip

# Install Flask
pip3 install Flask gunicorn

# Create the application directory
# For Ubuntu, the default user is 'ubuntu'. For Amazon Linux, it's 'ec2-user'.
# We'll create the directory in /var/www to be more distribution-agnostic for web apps.
mkdir -p /var/www/web_app
# Change ownership to the 'ubuntu' user for the application
sudo chown -R ubuntu:ubuntu /var/www/web_app
cd /var/www/web_app

# Create the Python Flask application
cat <<EOF > app.py
from flask import Flask
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    return f"Hello from Flask app on instance: {hostname}!"

if __name__ == '__main__':
    # Gunicorn will manage the server, but for direct testing:
    # app.run(host='0.0.0.0', port=80)
    pass
EOF

# Create a Gunicorn service file
cat <<EOF > /etc/systemd/system/web_app.service
[Unit]
Description=Gunicorn instance for web_app
After=network.target

[Service]
User=ubuntu 
Group=ubuntu 
WorkingDirectory=/var/www/web_app 
ExecStart=/usr/bin/env gunicorn --workers 4 --bind 0.0.0.0:8080 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the Gunicorn service
sudo systemctl daemon-reload
sudo systemctl start web_app
sudo systemctl enable web_app

# Ensure the service is running
sudo systemctl status web_app



