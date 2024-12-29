#!/bin/bash

# OpenLiteSpeed Installer Script
# Tested on Ubuntu 20.04/22.04 and CentOS 7/8

echo "Starting OpenLiteSpeed Installation..."

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Unsupported OS. Exiting..."
    exit 1
fi

# Update and install required dependencies
echo "Updating packages and installing dependencies..."
if [ "$OS" == "ubuntu" ]; then
    apt update && apt install -y wget gnupg
elif [ "$OS" == "centos" ]; then
    yum update -y && yum install -y wget
else
    echo "Unsupported OS. Exiting..."
    exit 1
fi

# Add OpenLiteSpeed repository
echo "Adding OpenLiteSpeed repository..."
if [ "$OS" == "ubuntu" ]; then
    wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | bash
elif [ "$OS" == "centos" ]; then
    wget -O - http://rpms.litespeedtech.com/centos/enable_lst_centos_repo.sh | bash
fi

# Install OpenLiteSpeed
echo "Installing OpenLiteSpeed..."
if [ "$OS" == "ubuntu" ]; then
    apt update && apt install -y openlitespeed
elif [ "$OS" == "centos" ]; then
    yum install -y openlitespeed
fi

# Start and enable OpenLiteSpeed service
echo "Starting OpenLiteSpeed service..."
systemctl start lsws
systemctl enable lsws

# Display admin credentials
echo "OpenLiteSpeed installed successfully!"
echo "Default admin credentials: admin / 123456"
echo "Change your admin password using:"
echo "/usr/local/lsws/admin/misc/admpass.sh"

# Display server details
IP=$(hostname -I | awk '{print $1}')
echo "Access your server at: http://$IP:8088"
echo "Admin panel: https://$IP:7080"

# Finish
echo "Installation complete!
