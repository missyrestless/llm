#!/bin/bash

export PYENV_ROOT="/usr/local/share/llm/.venv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

source ${PYENV_ROOT}/bin/activate

pip install huggingface_hub

python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='meta-llama/Llama-3.2-1B-Instruct', local_dir='/usr/local/share/models/llama-3.2-1b-instruct')"
