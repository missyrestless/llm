#!/bin/bash
#
# Benchmarking vLLM throughput
#
# Performance testing helps you determine how many prompts per second your infrastructure can support.
# Benchmarking is especially important when tuning concurrency, prompt size, and model selection.
#
# These tests can help identify the best values for throughput, latency, and request batching
# in your Ubuntu vLLM deployment.

export PYENV_ROOT="/usr/local/share/llm/.venv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

source ${PYENV_ROOT}/bin/activate

pip install aiohttp

python3 benchmarks/benchmark_throughput.py --backend vllm --model meta-llama/Llama-3.2-1B-Instruct --dataset ShareGPT_V3_unfiltered_cleaned_split.json --num-prompts 1000 --request-rate 10

python3 benchmarks/benchmark_serving.py --backend openai-chat --model llama-3.2-1b --base-url http://localhost:8000 --num-prompts 100
