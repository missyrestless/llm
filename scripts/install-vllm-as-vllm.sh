#!/bin/bash

export PATH="/home/vllm/.local/bin:/usr/local/bin:/usr/bin:${PATH}"

have_pip=$(type -p pip)
[ "${have_pip}" ] || {
  echo "Cannot locate pip in PATH"
  exit 1
}

cd /home/vllm

echo " --------------- "
echo "| Installing uv |"
echo " --------------- "
curl -LsSf https://astral.sh/uv/install.sh | sh

have_uv=$(type -p uv)
[ "${have_uv}" ] || {
  echo "Cannot locate uv in PATH"
  exit 1
}

echo " --------------------------------------- "
echo "| Installing Python virtual environment |"
echo " --------------------------------------- "
uv venv --python 3.12 --clear --seed --managed-python > install-venv.log 2>&1
source .venv/bin/activate

echo " ----------------- "
echo "| Installing vllm |"
echo " ----------------- "
uv pip install vllm --torch-backend=auto > install-vllm.log 2>&1

echo " --------------- "
echo "| Installing hf |"
echo " --------------- "
uv tool install hf > install-hf.log 2>&1
