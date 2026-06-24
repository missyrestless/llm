#!/bin/bash

nvidia-smi

nvcc --version || nvidia-smi | grep "CUDA Version"

nvidia-smi --query-gpu=memory.total,memory.free --format=csv
