# 🚀 Boundless Prover Node Setup and Run Guide

 **Boundless is a universal protocol that brings ZK to every chain, By abstracting away the complexity of proof generation, aggregation, and onchain settlement, Boundless allows developers to build without worrying about underlying infrastructure**

 
## This guide will help you set up and run the **Boundless Prover Node** easily on a Linux system. Just copy, paste, run the commands, and follow the prompts.

> I have made significant effort to simplify the process and make it easy to run.

---

## 📋 Prerequisites

Ensure you meet the following system and software requirements:

- **OS**: Ubuntu 22.04 (Required)
- **Hardware**:
  - High-performance NVIDIA GPU (e.g., 3090, 4090, A6000+)
  - Clock Speed: ≥ 3.0GHz boost
  - RAM: 32 GB DDR4
  - Storage: 200 GB SSD (NVMe preferred)
- **CLI Tools**: `git`, `cargo`, `docker`, `docker-compose`, `just`, `nvidia-container-toolkit`

---

## 📁 Repository Structure

This repository contains two main files:

- `setup-boundless.sh` → for installing dependencies and preparing the environment.
- `run-boundless.sh` → for starting and managing the prover node.

The setup file checks for required dependencies and installs only what's missing.

---

## ☁️ Deployment Options

### 🔹 Cloud Platform (Recommended)

Use [Vast.ai](https://cloud.vast.ai/?ref_id=62897&creator_id=62897&name=Ubuntu%2022.04%20VM) — known to work well since it offers an Ubuntu 22.04 VM (not the PyTorch or Docker template).

- Ideal if you don’t have local access to high-end hardware.
- Make sure to expose Docker and allow GPU access.

### 🔸 Local PC

Use a machine like an Alienware M18 or a desktop with an RTX 4090 for best performance.

- Gives you full control and better performance predictability.
- Ensure Docker, NVIDIA drivers, and `just` are installed.

If you're new to GPU rentals, check this repo on how to rent Vastai:  
👉 [Rent a GPU](https://github.com/Jaytechent/Rent-Graphic-Processing-Unit.git)




---

## 🔧 Step 1: Clone the Repository

```bash
git clone https://github.com/Jaytechent/Boundless-prover.git
cd Boundless-prover

```


## 🔧 Step 2: Setup Boundless Prover
This step will:


- Install Docker and NVIDIA Docker if not installed

- Clone the Boundless repo and checkout the correct branch

- Install Rust and other necessary Rust toolchains and tools

- Create an .env.broker file with your secrets and environment variables

## Setup Instructions

To run this project, you'll need the following environment variables to create a `.env.broker` file:

- `PRIVATE_KEY`
- `RPC_URL`
- `MARKET_ADDRESS`
- `VERIFIER_ADDRESS`
- `ORDER_STREAM_URL`

> ⚠️ **Note:** These values are different for each supported blockchain on Boundless. Make sure you use the correct values for the specific chain you intend to use.

👉 [**Click here to get the values**](https://docs.beboundless.xyz/developers/smart-contracts/deployments)

---

## Rent a GPU

If you need to rent a GPU for this project:

👉 [**Click here to rent a GPU**](https://github.com/Jaytechent/Rent-Graphic-Processing-Unit.git)

*NB: To get role prover and developer roles, you need to run on Base mainnet.*

Run this command to start setup:

```bash
chmod +x setup-boundless.sh
./setup-boundless.sh
```

You'll be prompted to paste:

- PRIVATE_KEY (your wallet private key)

- RPC_URL (The particular blockchain RPC endpoint you want to run)

- BOUNDLESS_MARKET_ADDRESS

- SET_VERIFIER_ADDRESS

- ORDER_STREAM_URL

* After a succesful installation, you should see something like this:
![image](https://github.com/user-attachments/assets/666cbcd4-b2ef-448e-9c77-2ad9521bbfeb)



Before the prover, load the env with

```bash
source .env.broker
```

🏃 Step 3: Run Boundless Prover Node
Once setup is complete, run this command to start the prover:

```bash
chmod +x run-boundless.sh
./run-boundless.sh
```
This script will:

- Load your .env.broker environment variables

- Confirm that your essential secrets are set

- Ask if you want to deposit 10 USDC as a stake (you can type yes or no)

- Start the Boundless broker using just commands

If successful, you should see a screen like this:
![image](https://github.com/user-attachments/assets/4af07b3d-18c4-4c63-b7d9-bb90d5903f51)

- Good Logs like this early:

  ![image](https://github.com/user-attachments/assets/08201e36-d6a4-426c-b278-b06167fd7408)




# 🛠️ Useful Commands After Starting
Monitor logs:

```bash
just broker logs
```

Stop the broker:

```bash
just broker down
```
Clean broker data:

```bash

just broker clean
```

To start the broker
```bash

just broker up
```

# 🔍 Troubleshooting Tips
If you get .env.broker not found error:
Make sure you ran the setup script successfully with no errors

- Alternatively, you may export all the 5 ENV variables manually:

```bash
export PRIVATE_KEY=<YOUR_PRIVATEKEY>
export RPC_URL=<the_rpc_for_that_chain>
export BOUNDLESS_MARKET_ADDRESS=<market_addr>
export SET_VERIFIER_ADDRESS=<value>
export ORDER_STREAM_URL=<the_value>
```

- If your log says your staking balance is low:
```bash
boundless account deposit-stake 10
```
(replace 10 with the amount of USDC you want to stake)

Docker/NVIDIA Issues:
If docker or nvidia-docker is not installed, the setup script will install them

You might need to log out and log back in for permissions to take effect

if your log says your staking balance is low



Run

```bash
boundless account deposit-stake 10
```

replace 10 with the amount of usdc you want to stake.

**Go to boundless guild to claim prover role, Developer role is achieved after your node take some orders but prover node is instant immediately you stake**

![image](https://github.com/user-attachments/assets/0207ed27-56f6-41b6-967f-739bf1cb6bd2)




If docker or nvidia-docker is not installed, the setup script will install them — but you might need to log out and log back in for permissions to take effect.

## To Increase the segment or any other setting on the setup file and run file

You can do so by editing the .env.broker file, the set and run file as follows;

Just run
```bash 
nano .env.broker
```

```bash
nano setup-boundless.sh
```

```bash
nano .run-boundless.sh
```


This guide will be updated as we prove along here and on my X account (https://x.com/HallenjayArt)
