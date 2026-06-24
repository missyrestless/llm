#!/bin/bash
#
sudo docker stop $(docker ps -aq)
sudo docker rm $(docker ps -aq)
sudo docker system prune -a --volumes

sudo systemctl stop docker.socket
sudo systemctl stop docker

sudo apt-get purge -y docker-engine docker.io containerd runc docker-ce docker-ce-cli

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

