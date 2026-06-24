#!/bin/bash
#
# Using quantized models to reduce VRAM usage
#
# Quantization is a practical way to run larger models on smaller GPUs.
# vLLM supports several quantized model formats that can lower memory
# requirements while preserving useful inference speed.

export PYENV_ROOT="/usr/local/share/llm/.venv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

source ${PYENV_ROOT}/bin/activate

# Example with AWQ:

# python3 -m vllm.entrypoints.openai.api_server --model TheBloke/Llama-2-13B-chat-AWQ --quantization awq --max-model-len 4096

# Example with GPTQ:

# python3 -m vllm.entrypoints.openai.api_server --model TheBloke/Llama-2-13B-chat-GPTQ --quantization gptq

# Example with bitsandbytes:

python3 -m vllm.entrypoints.openai.api_server --model meta-llama/Llama-3-70B-Instruct --quantization bitsandbytes --load-format bitsandbytes --tensor-parallel-size 4
