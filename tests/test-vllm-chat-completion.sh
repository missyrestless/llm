#!/bin/bash

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

curl -s -N http://127.0.0.1:8000/v1/chat/completions \
  -H "Authorization: Bearer ${VLLM_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-7b",
    "stream": true,
    "messages": [{"role": "user", "content": "In one sentence, what is PagedAttention?"}]
  }' | head -20
