#!/bin/bash
#
# This script installs vLLM using a separate Python virtual environment
# It creates a system user, vllm, to run the install process
#
# See https://computingforgeeks.com/install-vllm-linux-production
#
# Create the vllm system user
sudo useradd -r -m -d /home/vllm -s /bin/false vllm
# Create folders and environment with proper permissions
sudo install -d -m 0755 -o root -g root /etc/vllm
sudo install -d -m 0755 -o vllm -g vllm /var/log/vllm
sudo tee /etc/vllm/env >/dev/null <<'EOF'
HF_HOME=/home/vllm/hf-cache
HF_HUB_OFFLINE=1
VLLM_API_KEY=sk-cfg-demo-key
EOF
sudo chown vllm:vllm /etc/vllm/env
sudo chmod 600 /etc/vllm/env

# Install Python venv package
sudo apt install -y python3-venv curl ca-certificates
# Install uv as vllm user
curl -LsSf https://astral.sh/uv/install.sh | sudo -u vllm sh
# Create a separate Python virtual environment for vLLM
sudo -u vllm /home/vllm/.local/bin/uv venv /home/vllm/.venv --python 3.12 --seed
# Install vLLM, PyTorch matched to CUDA build, FlashAttention, xFormers,
# the vLLM kernels, and the OpenAI compatible server
sudo -u vllm /home/vllm/.local/bin/uv pip install --python /home/vllm/.venv/bin/python vllm --torch-backend=auto

# Download a model from Huggingface
sudo -u vllm /home/vllm/.venv/bin/pip install --quiet huggingface_hub
sudo -u vllm /home/vllm/.venv/bin/huggingface-cli download Qwen/Qwen2.5-7B-Instruct

# Start the vLLM server
sudo -u vllm /home/vllm/.venv/bin/vllm serve Qwen/Qwen2.5-7B-Instruct \
  --host 127.0.0.1 --port 8000 \
  --api-key sk-cfg-demo-key \
  --gpu-memory-utilization 0.90 \
  --max-model-len 16384 \
  --max-num-seqs 128 \
  --served-model-name qwen2.5-7b
