#!/bin/bash

apt-get update
apt-get upgrade

# Install Docker
sudo curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER 

# setup proxy-server
git clone --recurse-submodules https://github.com/evertramos/nginx-proxy-automation.git proxy

cd proxy/bin && sudo ./fresh-start.sh --yes -e ${EMAIL}

mkdir ~/wordpress-sites && cd ~/wordpress-sites

cat << EOF > docker-compose.yml
${dockercompose}
EOF

cat << EOF > .env
${envfile}
EOF

mkdir -p ./php-fpm && touch ./php-fpm/www.conf

docker compose up -d