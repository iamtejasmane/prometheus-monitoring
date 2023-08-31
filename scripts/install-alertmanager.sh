#!/bin/bash

# Download Prometheus AlertManager:
wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz

# Extract the files
tar xzf alertmanager-0.25.0.linux-amd64.tar.gz

# Create a Prometheus user, required directories, and make prometheus user as the owner of those directories
groupadd -f alertmanager
useradd -g alertmanager --no-create-home --shell /bin/false alertmanager
mkdir -p /etc/alertmanager/templates
mkdir /var/lib/alertmanager
chown alertmanager:alertmanager /etc/alertmanager
chown alertmanager:alertmanager /var/lib/alertmanager

# Move the downloaded Prometheus AlertManager binary:
mv alertmanager-0.25.0.linux-amd64 alertmanager-files

# Install Prometheus AlertManager:
cp alertmanager-files/alertmanager /usr/bin/
cp alertmanager-files/amtool /usr/bin/
chown alertmanager:alertmanager /usr/bin/alertmanager
chown alertmanager:alertmanager /usr/bin/amtool

# Install Prometheus AlertManager Configuration File:
cp alertmanager-files/alertmanager.yml /etc/alertmanager/alertmanager.yml
chown alertmanager:alertmanager /etc/alertmanager/alertmanager.yml

# Setup Prometheus AlertManager Service:
# vi /usr/lib/systemd/system/alertmanager.service 

# Add the altermanager.service configuration and save the file:
# [Unit]
# Description=AlertManager
# Wants=network-online.target
# After=network-online.target

# [Service]
# User=alertmanager
# Group=alertmanager
# Type=simple
# ExecStart=/usr/bin/alertmanager \
#     --config.file /etc/alertmanager/alertmanager.yml \
#     --storage.path /var/lib/alertmanager/

# [Install]
# WantedBy=multi-user.target

# OR
cat altermanager.service > /usr/lib/systemd/system/alertmanager.service 

# Update permissions
chmod 664 /usr/lib/systemd/system/alertmanager.service

# Reload systemd and Register Prometheus AlertManager:
systemctl daemon-reload
systemctl start alertmanager

# Check the alertmanager service status using the following command.
systemctl status alertmanager