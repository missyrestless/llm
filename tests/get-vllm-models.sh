#!/bin/bash

export PYENV_ROOT="/usr/local/share/llm/.venv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

if [ -r /etc/open-webui/env ]; then
  source /etc/open-webui/env
  [ "${VLLM_API_KEY}" ] || {
    echo "ERROR: VLLM_API_KEY not set in /etc/open-webui/env"
    exit 1
  }
else
  echo "ERROR: cannot read /etc/open-webui/env"
  exit 1
fi

source ${PYENV_ROOT}/bin/activate

curl -s http://127.0.0.1:8000/v1/models \
     -H "Authorization: Bearer ${VLLM_API_KEY}" | python3 -m json.tool
