#!/bin/bash

set -e

echo "=== Boundless Prover Runner script ==="

cd boundless || { echo "❌ Run setup script first!"; exit 1; }

# Load .env.broker only
if [ -f .env.broker ]; then
  echo ">>> Loading .env.broker..."
  set -a
  source .env.broker
  set +a
else
  echo "❌ .env.broker not found!"
  exit 1
fi

# Confirm essential environment variables
if [[ -z "$PRIVATE_KEY" || -z "$RPC_URL" ]]; then
  echo "❌ Missing PRIVATE_KEY or RPC_URL in .env.broker!"
  exit 1
fi

echo "✅ Environment loaded"
echo "→ Wallet: ${PRIVATE_KEY:0:6}... (truncated)"
echo "→ RPC URL: $RPC_URL"
echo "→ Verifier: $VERIFIER_ADDRESS"

# Optional stake deposit
read -p "Do you want to deposit 10 USDC as stake now? (yes/no): " CONFIRM
if [ "$CONFIRM" == "yes" ]; then
    echo "Depositing 10 USDC (10000000 base units)..."
    boundless account deposit-stake 10000000 --rpc "$RPC_URL"
else
    echo ">>> Skipping stake deposit."
fi

# Start the broker
echo "🚀 Starting Boundless broker with .env.broker..."
just broker up ./.env.broker

echo ""
echo "✅ Broker running!"
echo "👉 Monitor logs: just broker logs"
echo "👉 Stop broker: just broker down"
echo "👉 Clean data: just broker clean"
