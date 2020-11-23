#!/bin/sh

# Check If Validate
if [[ $# -eq 0 ]] ; then
    echo 'Usage : ./install.sh [IP ADDRESS]'
    exit 1
fi

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo rm get-docker.sh
sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker

# Install Docker-Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Harbor
sudo curl -L "https://github.com/goharbor/harbor/releases/download/v2.1.0/harbor-online-installer-v2.1.0.tgz" -o harbor.tgz
tar xvf harbor.tgz
sudo rm harbor.tgz

cp ./harbor/harbor.yml.tmpl ./harbor/harbor.yml
sed -i "5s/.*/hostname: $1/" ./harbor/harbor.yml
sed -i "13s/^/#/" ./harbor/harbor.yml
sed -i "15s/^/#/" ./harbor/harbor.yml
sed -i "17s/^/#/" ./harbor/harbor.yml
sed -i "18s/^/#/" ./harbor/harbor.yml

cd harbor && sudo ./install.sh && sudo docker-compose up -d && cd ..

# Clean up
sudo rm install.sh