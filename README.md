# Blockcast BEACON Node – One-Click Installation Guide

This guide helps you install and register a **Blockcast BEACON node** in just a few steps using a single shell script. No manual Docker setup required.

---

## 📦 Prerequisites

- A Linux/macOS/WSL machine with internet access
- Basic terminal/command-line knowledge
- Docker installed (or this script will install it for you)
- Git installed

---



# METHOD 1. - ONE CLICK INSTALLATION
### 1. Install `curl` and `wget` (if missing)

```bash
(command -v curl >/dev/null 2>&1 && command -v wget >/dev/null 2>&1) || sudo apt-get update; command -v curl >/dev/null 2>&1 || sudo apt-get install -y curl; command -v wget >/dev/null 2>&1 || sudo apt-get install -y wget
```

---

### 2. Download and run the setup script

```bash
[ -f "blockcast.sh" ] && rm blockcast.sh; curl -sSL -o blockcast.sh https://raw.githubusercontent.com/codewithalexsz/blockcastnode/main/blockcast.sh && chmod +x blockcast.sh && sudo ./blockcast.sh
```

This script will:

- Install Docker if it's not present
- Set permissions so Docker works without `sudo`
- Clone the Blockcast Docker repository
- Start and initialize your Blockcast node
- Print your node registration details

---


# 💪 Step-by-Step Setup ( METHOD 2 )

## a.🔧 Docker Installation
 Run the following code line by line to install Docker:

```bash
sudo apt update -y && sudo apt upgrade -y
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y && sudo apt upgrade -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl restart docker
sudo usermod -aG docker $USER
```

---

### b. install blockcast node

```bash
git clone https://github.com/Blockcast/beacon-docker-compose.git && cd beacon-docker-compose && docker compose up -d
```
### c. When BEACON runtime is up, run below code
```
docker compose exec blockcastd blockcastd init
```
This command outputs:
- 🔑 **Hardware ID**
- 🔐 **Challenge Key**
- 🔗 **Registration URL**

---

# 3. Register Your Node ( POST INSTALLATION )

You can now register your node using one of these two methods:

#### ✅ Automatic (Recommended):
Open the **registration URL** shown in the terminal after running the script.

#### 📝 Manual:
1. Go to: [manage nodes](https://app.blockcast.network?referral-code=gvQqkm)
2. Click **"Register Node"**
3. Paste in the **Hardware ID** and **Challenge Key**
4. Allow browser location access when prompted

---

### 4. Verify Node Health

After successful registration:
- Your node will appear on the `/manage-nodes` dashboard.
- It may take a few minutes for status to show as **Healthy**
- Click on the node to view uptime, rewards, and performance data

---

### 5. Keep Your Node Online

- ⏱️ **Minimum uptime**: 6 hours for first connectivity test
- 💰 **Reward eligibility**: Starts after 24 hours of uptime

---

## 🔒 Backup Instructions

Make sure to **back up your private key**:

```bash
~/.blockcast/certs/gw_challenge.key
```

> 📂 If you lose this key, you won’t be able to prove ownership of the node.

---

## 💬 FAQs

- **Can I run multiple BEACON nodes?**  
  ➤ Yes, but each must be on a **unique public IP** and **registered under a separate Blockcast account**.

- **Does this work on macOS or Windows?**  
  ➤ Yes. This script runs on any OS that supports Docker (including macOS, Linux, and WSL on Windows).

- **Where can I read more?**  
  ➤ Visit the official docs: [docs.blockcast.network](https://docs.blockcast.network/main/getting-started/how-do-i-participate-in-the-network/beacon/start-running-your-beacon-today)

---

## 📜 License

MIT License – use freely, contribute improvements, and help decentralize!
