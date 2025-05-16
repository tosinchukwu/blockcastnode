#!/bin/bash

set -e

echo "🚀 Starting Blockcast BEACON node installation..."

# 1. Install Docker if not present
if ! command -v docker &> /dev/null; then
  echo "🔧 Docker not found. Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  rm get-docker.sh
else
  echo "✅ Docker is already installed."
fi

# 2. Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
  echo "🔧 Docker Compose not found. Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo "✅ Docker Compose is already installed."
fi

# 3. Clone the BEACON Docker Compose repository
echo "📦 Cloning the BEACON Docker Compose configuration..."
git clone https://github.com/Blockcast/beacon-docker-compose.git
cd beacon-docker-compose

# 4. Launch the BEACON services
echo "🚀 Launching the BEACON services..."
docker-compose up -d

# 5. Wait for services to initialize
echo "⏳ Waiting for services to initialize..."
sleep 10

# 6. Generate Hardware ID and Challenge Key
echo "🔑 Generating Hardware ID and Challenge Key..."
docker-compose exec blockcastd blockcastd init
