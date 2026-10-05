#!/bin/bash

sudo apt-get update
sudo apt-get install -y stress-ng


cat <<EOF >  /etc/systemd/system/stress-ng.service
[Unit]
Description=Stress ng service
After=network.target

[Service]
Type=simple
WorkingDirectory=/tmp
ExecStart=/usr/bin/stress-ng --cpu 0 --cpu-load 100
Restart=no
User=ubuntu
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
