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

python3 -m vllm.entrypoints.openai.api_server --model meta-llama/Llama-3-8B-Instruct --host 0.0.0.0 --port 8000 --tensor-parallel-size 2 --max-model-len 4096 --gpu-memory-utilization 0.90 --dtype bfloat16 --max-num-seqs 256 --enable-chunked-prefill --api-key "${VLLM_API_KEY}"

# Important parameters include:
#
# tensor-parallel-size to distribute inference across multiple GPU
# smax-model-len to limit context size and reduce memory pressure
# gpu-memory-utilization to define how aggressively vLLM uses available VRAM
# dtype to control numerical precision based on your GPU architecture
# max-num-seqs to tune concurrency
#
# How to test the vLLM API server
#
# After the server is running, send a request to confirm that inference works correctly.

curl http://localhost:8000/v1/chat/completions -H "Content-Type: application/json" -d '{"model":"llama-3.2-1b","messages":[{"role":"user","content":"Explain what a KV cache is in 2 sentences."}],"max_tokens":200,"temperature":0.7}'

# You can also test classic text completion behavior:

curl http://localhost:8000/v1/completions -H "Content-Type: application/json" -d '{"model":"llama-3.2-1b","prompt":"The capital of France is","max_tokens":50}'

# To view the list of models currently exposed by the service:

curl http://localhost:8000/v1/models
