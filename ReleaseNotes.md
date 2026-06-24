# Ollama and vLLM with Open WebUI Release Notes

This release adds support for:

- Quantized model `Qwen/Qwen3.6-27B-FP8` served with `vLLM`
- Installation and configuration of `vLLM` with systemd unit and `Open WebUI` integration
- Installation and configuration of `Open Terminal` with systemd unit and `Open WebUI` integration
- Installation options with `./install` command line arguments
- Installation and configuration of `ComfyUI` image generation engine
- Scripts for installing `vLLM` and Llama server
- Additional `Open WebUI` auto-configuration
- Installation and configuration of an Ollama server and systemd unit
- Installation and configuration of Open WebUI and systemd unit
  - Open WebUI Okta authentication
- Installation of Model Context Protocol (MCP)
- Installation of llm command line 
- LM Studio systemd unit for automatic startup of lms daemon
- Additional Ollama models download and `lms` model downloads
- Installation and configuration of Nginx reverse proxy

See the [llm repository README](https://github.com/missyrestless/llm#readme) for installation and configuration details.

## Automated installation and configuration

Automated installation and configuration of this deployment is provided.
The LetsEncrypt certificates and a `.secrets` file must be manually provided.

The `.secrets` file contains the following settings:

```bash
# A Github API access token
GH_TOKEN='<REDACTED>'
# A Huggingface token
HF_TOKEN='<REDACTED>'
# Open Terminal user password
TERM_PASS='<REDACTED>'
```
To install:

```bash
git clone https://github.com/missyrestless/llm.git
cd llm
cp /path/to/.secrets .secrets
chmod 600 .secrets
# Without arguments use vLLM, not Ollama - invoke with -A for both or -O for Ollama only
./install
```

The `install` script provides automated installation and configuration of:

- Open WebUI
- Ollama
  - Ollama models
- vLLM
  - Huggingface models
- LM Studio CLI
- ComfyUI image generation
- Huggingface Hub
- Llama.cpp
- llm CLI
- Claude Code
- Additional tools
- Nginx reverse proxy
- Systemd system services
  - comfyui.service
  - lmstudio.service
  - ollama.service
  - openterminal.service
  - openwebui.service
  - vllm.service

## Install script usage

```
Usage: ./install [-A] [-c] [-I] [-L] [-O] [-p] [-h|-u]
Where:
	-A indicates install both Ollama and vLLM
	-c indicates install CUDA Toolkit and exit, no other installation performed
	-I indicates download ComfyUI models and exit, no installation performed
	-L indicates install LM Studio Core and lmster
	-p indicates download/pull models and exit, no installation performed
	-O indicates install Ollama, do not install vLLM
	-h or -u displays this usage message and exits

Without arguments ./install installs vLLM and does not install Ollama
Typical test/dev usage would be to run ./install -O first, verify system ok, then run ./install -p
Typical production deployment would run ./install (vLLM only) or ./install -A
```

## Open WebUI

`Open WebUI` is an extensible, feature-rich, and user-friendly self-hosted AI platform designed
to operate entirely offline. It supports Ollama and OpenAI-compatible APIs, making it a powerful,
provider-agnostic solution for both local and cloud-based models.

The `install` script installs and configures Open WebUI with Ollama integration and Okta authentication.
Open WebUI is configured to run securely behind an Nginx reverse proxy.

### Ollama and Open WebUI

Ollama and Open WebUI are the most popular pairing in the local AI ecosystem.
Ollama manages and serves your models; Open WebUI adds a web-based platform
with knowledge management, team features, and extensibility on top.

Open WebUI auto-detects Ollama when running on the same machine. All your Ollama
models show up in the model selector immediately, no configuration needed.

The `install` script installs and configures both Ollama and Open WebUI.
By default, Open WebUI will be preconfigured with all Ollama models in the selector.

### LM Studio and Open WebUI

LM Studio's OpenAI-compatible API server works well as a backend for Open WebUI.
You can use LM Studio to manage and serve your local models, then connect Open WebUI to LM Studio's API.

How to connect:

1. In LM Studio, start the local API server (default port 1234)
1. In Open WebUI, go to Admin → Settings → Connections
1. Add a new OpenAI-compatible connection with URL http://localhost:1234/v1
1. Your LM Studio models will appear in the model selector

### ChatGPT and Open WebUI

Open WebUI connects to the OpenAI API, so all of OpenAI's models (e.g. ChatGPT)
are available alongside Open WebUI's knowledge management, tools, and team features.

How to connect:

1. Get an API key from platform.openai.com
1. In Open WebUI, go to Admin → Settings → Connections
1. Add a new OpenAI connection with your API key
1. OpenAI models will appear in your model selector

Many users run OpenAI models for complex reasoning alongside local models via Ollama
for privacy-sensitive tasks, all in the same interface.

### Claude and Open WebUI

Claude models are available through Open WebUI via the Anthropic API. Many Open WebUI
users run Claude as their primary model, getting Claude's reasoning alongside Open WebUI's
knowledge bases, tools, and team features.

How to connect:

1. Get an API key from console.anthropic.com
1. In Open WebUI, go to Admin → Settings → Connections
1. Add a new connection with your Anthropic API key and the base URL https://api.anthropic.com/v1
1. Claude models will appear in your model selector

You can use Claude for complex analysis and writing while routing simpler tasks to
local models via Ollama, all in the same interface.

### Gemini and Open WebUI

Gemini models are available through Open WebUI via the Google AI API.
You can use Gemini's multimodal capabilities alongside other models you connect.

How to connect:

1. Get an API key from aistudio.google.com
1. In Open WebUI, go to Admin → Settings → Connections
1. Add a new connection with the base URL https://generativelanguage.googleapis.com/v1beta/openai and your Google AI API key
1. Gemini models will appear in your model selector

### llama.cpp and Open WebUI

llama.cpp's llama-server exposes an OpenAI-compatible API, which means Open WebUI can connect
to it directly. Use llama.cpp for high-performance inference, Open WebUI for the platform layer.

How to connect:

1. Start llama-server with `llama-server -m your-model.gguf --port 8081`
1. In Open WebUI, go to Admin → Settings → Connections
1. Add a new connection with the base URL http://localhost:8081/v1
1. llama.cpp models will appear in your model selector
