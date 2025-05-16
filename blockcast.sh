#!/bin/bash

# Formatting helpers
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
LIGHTBLUE='\033[1;34m'
BOLD='\033[1m'
RESET='\033[0m'

# Check if Docker is installed
echo -e "\n${CYAN}${BOLD}---- CHECKING DOCKER INSTALLATION ----${RESET}\n"
if ! command -v docker &> /dev/null; then
  echo -e "${LIGHTBLUE}${BOLD}Docker not found. Installing Docker...${RESET}"
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  sudo usermod -aG docker $USER
  rm get-docker.sh
  echo -e "${GREEN}${BOLD}Docker installed successfully!${RESET}"
fi

echo -e "${LIGHTBLUE}${BOLD}Setting up Docker to run without sudo for this session...${RESET}"
if ! getent group docker > /dev/null; then
  sudo groupadd docker
fi

sudo usermod -aG docker $USER

if [ -S /var/run/docker.sock ]; then
  sudo chmod 666 /var/run/docker.sock
  echo -e "${GREEN}${BOLD}Docker socket permissions updated.${RESET}"
else
  echo -e "${RED}${BOLD}Docker socket not found. Docker daemon might not be running.${RESET}"
  echo -e "${LIGHTBLUE}${BOLD}Starting Docker daemon...${RESET}"
  sudo systemctl start docker
  sudo chmod 666 /var/run/docker.sock
fi

if docker info &>/dev/null; then
  echo -e "${GREEN}${BOLD}Docker is now working without sudo.${RESET}"
else
  echo -e "${RED}${BOLD}Failed to configure Docker to run without sudo. Using sudo for Docker commands.${RESET}"
  DOCKER_CMD="sudo docker"
fi

# Clone Blockcast Docker repo
echo -e "${CYAN}${BOLD}---- CLONING BLOCKCAST DOCKER REPOSITORY ----${RESET}"
if [ ! -d "blockcast" ]; then
    git clone https://github.com/Blockcast/beacon-docker-compose.git blockcast
    cd blockcast || exit 1
else
    echo -e "${LIGHTBLUE}Directory 'blockcast' already exists. Skipping clone.${RESET}"
    cd blockcast || exit 1
fi

# Start Docker containers
echo -e "${CYAN}${BOLD}---- STARTING BLOCKCAST SERVICES ----${RESET}"
docker compose up -d

# Wait for container to initialize
echo -e "${LIGHTBLUE}Waiting for container to initialize...${RESET}"
sleep 15

# Run blockcastd init
echo -e "${CYAN}${BOLD}---- INITIALIZING NODE ----${RESET}"
docker compose exec blockcastd blockcastd init

# Notify user
echo -e "${GREEN}${BOLD}✔ Node initialized. Look above for your Hardware ID, Challenge Key, and Registration URL.${RESET}"
echo -e "${LIGHTBLUE}Visit https://app.blockcast.network/manage-nodes to register your node.${RESET}"
echo -e "${LIGHTBLUE}Back up your private key at ~/.blockcast/certs/gw_challenge.key${RESET}"

