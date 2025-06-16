#!/bin/bash

set -e

echo "=== Hallenjay Boundless Prover Setup Script ==="

# Step 0: Prompt for required secrets
read -p "Paste your PRIVATE_KEY: " PRIVATE_KEY
read -p "Paste your RPC_URL: " RPC_URL
read -p "Paste your BOUNDLESS_MARKET_ADDRESS: " MARKET_ADDRESS
read -p "Paste your SET_VERIFIER_ADDRESS: " VERIFIER_ADDRESS
read -p "Paste your ORDER_STREAM_URL: " ORDER_STREAM_URL

# Step 1: Install Docker
if ! command -v docker &> /dev/null; then
    echo ">>> Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
else
    echo ">>> Docker already installed. Skipping..."
fi

# Step 2: Install NVIDIA Docker
if ! dpkg -l | grep -q nvidia-docker2; then
    echo ">>> Installing NVIDIA Docker runtime..."
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt update && sudo apt install -y nvidia-docker2
    sudo systemctl restart docker
else
    echo ">>> NVIDIA Docker already installed. Skipping..."
fi

# Step 3: Clone Boundless repo
if [ ! -d "boundless" ]; then
    echo ">>> Cloning Boundless repo..."
    git clone https://github.com/boundless-xyz/boundless
    cd boundless
    git checkout release-0.10
else
    echo ">>> Boundless repo already cloned."
    cd boundless
fi

# Step 4: Setup Boundless dependencies
echo ">>> Running Boundless setup script..."
sudo ./scripts/setup.sh

# Step 5: Install Rust (general)
if ! command -v cargo &> /dev/null; then
    echo ">>> Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
else
    echo ">>> Rust already installed."
fi

# Ensure cargo bin is in PATH
if ! grep -q ".cargo/bin" <<< "$PATH"; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi

# Step 6: Install rzup (Risc0 Updater)
if ! command -v rzup &> /dev/null; then
    echo ">>> rzup not found. Installing rzup..."
    curl -L https://risczero.com/install | bash

    if ! grep -q ".risc0/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.risc0/bin:$PATH"' >> ~/.bashrc
    fi

    export PATH="$HOME/.risc0/bin:$PATH"
else
    echo ">>> rzup already installed."
fi



# Step 7: Install Risc Zero Rust toolchain
echo ">>> Installing Risc Zero Rust toolchain with rzup..."
rzup install rust

# Step 8: Install CLI tools
echo ">>> Installing Bento CLI and Boundless CLI..."
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli || true
cargo install --locked boundless-cli || true

# Step 9: Write .env.broker file
echo ">>> Creating .env.broker..."
cat <<EOF > .env.broker
# Prover node configs

RUST_LOG=info

REDIS_HOST=redis
REDIS_IMG=redis:7.2.5-alpine3.19

POSTGRES_HOST=postgres
POSTGRES_IMG=postgres:16.3-bullseye
POSTGRES_DB=taskdb
POSTGRES_PORT=5432
POSTGRES_USER=worker
POSTGRES_PASSWORD=password

MINIO_HOST=minio
MINIO_IMG=minio/minio:RELEASE.2024-05-28T17-19-04Z
MINIO_ROOT_USER=admin
MINIO_ROOT_PASS=password
MINIO_BUCKET=workflow

GRAFANA_IMG=grafana/grafana:11.0.0

SEGMENT_SIZE=21
RISC0_KECCAK_PO2=17

PRIVATE_KEY=${PRIVATE_KEY}
BOUNDLESS_MARKET_ADDRESS=${MARKET_ADDRESS}
SET_VERIFIER_ADDRESS=${VERIFIER_ADDRESS}
RPC_URL=${RPC_URL}
ORDER_STREAM_URL=${ORDER_STREAM_URL}
EOF

# Step 10: Move into boundless folder to prep for run
cd "$(pwd)/boundless"

echo ""
echo "🎉 Setup complete!"
echo "👉 Now run: ./run-boundless.sh"
