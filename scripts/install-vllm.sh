#!/bin/bash
#
SCRIPT_PATH="$(
  cd "$(dirname "$0")"
  pwd -P
)"
have_real=$(type -p realpath)
[ "${have_real}" ] && SCRIPT_PATH="$(realpath $SCRIPT_PATH)"

[ -x ${SCRIPT_PATH}/install-vllm-as-vllm.sh ] || {
  echo "Cannot locate ${SCRIPT_PATH}/install-vllm-as-vllm.sh"
  exit 1
}

TOP=$(dirname "${SCRIPT_PATH}")
cd "${TOP}"
[ -f ${TOP}/.secrets ] && source ${TOP}/.secrets

[ -d /home/vllm ] || {
  echo "ERROR: /home/vllm does not exist or is not a directory"
  exit 1
}

echo " ----------------- "
echo "| Installing vLLM |"
echo " ----------------- "
# Create folders and environment with proper permissions
sudo install -d -m 0755 -o root -g root /etc/vllm
sudo install -d -m 0755 -o vllm -g vllm /var/log/vllm
# Generate a secure vLLM API key
have_openssl=$(type -p openssl)
if [ "${have_openssl}" ]; then
  VLLM_API_KEY="sk-$(openssl rand -hex 32)"
else
  echo "WARNING: could not locate openssl in PATH, using dummy vLLM API key"
  VLLM_API_KEY='sk-cfg-demo-key'
fi
if [ -f env-vllm ]; then
  cat env-vllm | sed -e "s/sk-cfg-demo-key/${VLLM_API_KEY}/" > /tmp/vllm$$
  if [ "${HF_TOKEN}" ]; then
    sed -i -e "s/__HF_TOKEN__/${HF_TOKEN}/" /tmp/vllm$$
  else
    echo "WARNING: HF_TOKEN not found in environment"
    sed -i -e "s/__HF_TOKEN__//" /tmp/vllm$$
  fi
  sudo cp /tmp/vllm$$ /etc/vllm/env
else
  echo "export HF_HOME=/home/vllm/hf" > /tmp/vllm$$
  echo "export HF_HUB_DISABLE_TELEMETRY=1" >> /tmp/vllm$$
  if [ "${HF_TOKEN}" ]; then
    echo "export HF_TOKEN=${HF_TOKEN}" >> /tmp/vllm$$
  else
    warn "HF_TOKEN not found in environment"
  fi
  echo "export VLLM_API_KEY=${VLLM_API_KEY}" >> /tmp/vllm$$
  echo "export VLLM_HOST_IP=127.0.0.1" >> /tmp/vllm$$
  echo "export CUDA_VISIBLE_DEVICES=0" >> /tmp/vllm$$
  sudo cp /tmp/vllm$$ /etc/vllm/env
fi
rm -f /tmp/vllm$$
sudo chown vllm:hbadmin /etc/vllm/env
sudo chmod 640 /etc/vllm/env

sudo -u vllm ${SCRIPT_PATH}/install-vllm-as-vllm.sh
