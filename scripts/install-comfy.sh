#!/bin/bash
#
SRC="/mnt/llm"

[ -d ${SRC} ] || {
  echo "ERROR: $SRC does not exist or is not a directory. Exiting."
  exit 1
}

cd ${SRC}
rm -rf ComfyUI
git clone https://github.com/Comfy-Org/ComfyUI.git

source ${SRC}/.venv/bin/activate

cd ComfyUI
pip install -r requirements.txt

repo="Comfy-Org/stable-diffusion-v1-5-archive"
hfmodel="v1-5-pruned-emaonly-fp16.safetensors"

if [ -d "${SRC}/ComfyUI/models/checkpoints" ]; then
  have_hf=$(type -p hf)
  [ "${have_hf}" ] || {
    printf "\nModel download error:"
    printf "\n\tCannot locate hf command in PATH"
    printf "\nNo checkpoint model downloaded\n"
    exit 1
  }
  printf "\n\nDownloading ${hf_model} model\n"
  hf download --quiet --local-dir "${SRC}/ComfyUI/models/checkpoints" ${repo} ${hfmodel}
else
  printf "\nModel download error:"
  printf "\n\t${SRC}/ComfyUI/models/checkpoints does not exist or is not a directory"
  printf "\nNo checkpoint model downloaded\n"
  exit 1
fi
