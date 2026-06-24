# Open WebUI with vLLM and Ollama

This repository intends to serve as a guide to deploying `Open WebUI` and integrating
it with `Ollama`, `vLLM`, self-hosted large language models, and tools.

## Table of Contents

- [Installation](#installation)
  - [Installation Usage and Configuration](#installation-usage-and-configuration)
  - [Access and Hostnames](#access-and-hostnames)
- [Installing and using a Large Language Model](#installing-and-using-a-large-language-model)
  - [Installing and using a local LLM with Ollama](#installing-and-using-a-local-llm-with-ollama)
    - [Ollama README](doc/README-OLLAMA.md)
  - [Installing and using a local LLM with the LLM command line](#installing-and-using-a-local-llm-with-the-llm-command-line)
- [Open WebUI](#open-webui)
  - [Open WebUI Workspace Models](models/README.md)
  - [Ollama and Open WebUI](#ollama-and-open-webui)
  - [LM Studio and Open WebUI](#lm-studio-and-open-webui)
  - [ChatGPT and Open WebUI](#chatgpt-and-open-webui)
  - [Claude and Open WebUI](#claude-and-open-webui)
  - [Gemini and Open WebUI](#gemini-and-open-webui)
  - [llama.cpp and Open WebUI](#llama.cpp-and-open-webui)
- [ComfyUI Image Generation](#comfyui-image-generation)
- Additional Info
  - [Release Notes](ReleaseNotes.md)
  - [TODO List](TODO.md)
  - [Models README](models/README.md)
  - [OpenClaw doc](doc/OpenClaw.md)
  - [Ollama CLI reference](doc/OLLAMA-CLI-REF.md)
  - [What is the Model Context Protocol](doc/MCP.md)
  - [WrenAI and Open WebUI integration](doc/WrenAI-OpenWebUI.md)
- [See also](#see-also)

## Installation

Automated installation and configuration of this deployment is provided.
A `.secrets` file must be manually provided.

The `.secrets` file contains the following settings:

```bash
# A Github API access token
GH_TOKEN='<REDACTED>'
# A Huggingface token
HF_TOKEN='<REDACTED>'
# The Open Terminal user password
TERM_PASS='<REDACTED>'
```

To install:

```bash
git clone https://github.com/missyrestless/llm.git
cd llm
cp /path/to/.secrets .secrets
chmod 600 .secrets
# Use vLLM instead of Ollama, to use Ollama invoke with -O or -A for both
./install
```

The `install` script provides automated installation and configuration of:

- Open WebUI
- Open Terminal
- Ollama
  - Ollama models
- vLLM
  - Huggingface models
- LM Studio CLI
- Huggingface Hub
- ComfyUI image generation
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

### Installation Usage and Configuration

The `install` command accepts command line arguments to specify what gets installed/downloaded.
The usage message can be displayed with `./install -h`:

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

The initial deployment used `Ollama` as provider as that was the easiest and quickest way to
deploy/test. Production deployment uses the OpenAI-Compatible AI inference framework `vLLM`.

Installation and configuration of `vLLM` and an `Nginx` reverse proxy can be performed with:

```bash
./install
```

The best guide for production deployment of `vLLM` we have found thus far can be found at
https://computingforgeeks.com/install-vllm-linux-production

### Access and Hostnames

Access to Open WebUI is controlled via password authentication.

The following hostnames have been adopted for this deployment:

- `openwebui.neoman.dev` serves as the primary web user interface
  - Login with username/password at https://openwebui.neoman.dev
- `mcp.neoman.dev` serves as the HTTPS protocol server for MCP servers 
- `openai.neoman.dev` serves as the OpenAI-Compatible server for locally hosted OpenAI requests
  - An API key is required to make requests
  - This service is locally hosted and does not require a paid subscription
  - Plans include Multi-tenant API keys with `LiteLLM` and alerts with `Prometheus` and `Grafana`

These hostnames are not yet in DNS. In order to access them you must add the
following to `/etc/hosts` on your client machine:

`10.240.128.89  openwebui.neoman.dev mcp.neoman.dev openai.neoman.dev`

#### Ports

The following ports are used by the specified services:

- 80/443 : Nginx serving as reverse proxy
- 6000   : Open WebUI server
- 8000   : vLLM with Qwen/Qwen2.5-7B-Instruct
- 8188   : ComfyUI image generation
- 8443   : MCP server
- 9000   : Open Terminal
- 11434  : Ollama server

Not yet deployed:

- 8002   : Second vLLM server
- 10000  : Llama.cpp
- 18789  : OpenClaw

## Installing and using a Large Language Model

A large language model (LLM) is a neural network trained on a vast amount of text for
natural language processing tasks, especially language generation. LLMs can typically
generate, summarize, translate, and analyze text in many contexts, and are a
foundational technology behind modern chatbots.

### Installing and using a local LLM with Ollama

`Ollama` is an open-source software platform for running and managing large language models
on local computers and through hosted cloud models. It provides a command-line interface,
a native GUI, a local REST API, model-management tools, and integrations for using
open-weight models with coding assistants and other applications.

`Ollama` can be installed with the command:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Once installed, use the command `ollama models` to list available models. Selection of an
appropriate model is critical and depends upon the context in which it will be used and
the capabilities/resources/performance of the environment in which it will run. Select
a model that supports `tools` to enable connection to external resources and select
a model that will perform adequately within the limits of available memory.

Download and run the desired LLM (`qwen3.5:9b` is used as an example) with the commands:

```bash
ollama pull qwen3.5:9b
ollama run qwen3.5:9b
```

If more memory is available, a larger more complex model may be used. For example, `qwen3.5:35b`.
Some simple tests can reveal whether your runtime environment supports the model selected
or whether you need to run a smaller/larger model. Run the command `ollama run <model name>`
and at the prompt provide some simple request like "What are you capable of doing?".

`Ollama` has excellent documentation and a multitude of community projects providing various
capabilities built on top of `Ollama`. See the [Ollama README](doc/README-OLLAMA.md) for details.

### Installing and using a local LLM with the LLM command line

The `LLM` project provides a CLI tool and Python library for interacting with OpenAI,
Anthropic’s Claude, Google’s Gemini, Meta’s Llama and dozens of other Large Language Models,
both via remote APIs and with models that can be installed and run on your own machine.

Watch [Language models on the command-line](https://www.youtube.com/watch?v=QUXQNi6jQ30)
on YouTube for a demo or read the
[accompanying detailed notes](https://simonwillison.net/2024/Jun/17/cli-language-models/).

The `LLM` command line tool and Python library can be installed with the `install` script in this repository:

```bash
./install
```

See https://llm.datasette.io/en/stable/other-models.html#installing-and-using-a-local-model
for more notes on installing and using local models.

## Open WebUI

`Open WebUI` is an extensible, feature-rich, and user-friendly self-hosted AI platform designed
to operate entirely offline. It supports Ollama and OpenAI-compatible APIs, making it a powerful,
provider-agnostic solution for both local and cloud-based models.

The `install` script installs and configures Open WebUI with Ollama and vLLM integration.
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

## ComfyUI Image Generation

The `ComfyUI` image generation engine can be reached at https://openwebui.neoman.dev/image

### Setting Up Open WebUI with ComfyUI

#### Step 1: Configure Open WebUI Settings

1. Go to Admin Panel in Open WebUI.
1. Click Settings, then select the Images tab.
1. In the Image Generation Engine field, select ComfyUI.
1. Enter the API URL where ComfyUI is running: https://openwebui.neoman.dev/image
1. Set the environment variable COMFYUI_BASE_URL to this address to ensure it’s persistent in the WebUI.

#### Step 2: Verify Connection and Enable Image Generation

1. Make sure ComfyUI is running, then verify the connection with Open WebUI.
1. Once verified, toggle Image Generation (Experimental). You’ll now see additional options.

#### Step 3: Configure ComfyUI Settings and Import Workflow

1. Enable developer mode in ComfyUI by clicking the gear icon above the Queue Prompt button and enabling Dev Mode.
1. Export the desired workflow from ComfyUI using the Save (API Format) button. This will download the file as workflow_api.json.
1. In Open WebUI, click Click here to upload a workflow.json file, and select the workflow_api.json to import the workflow.
1. After importing, map the ComfyUI Workflow Nodes according to the imported node IDs.

**Info:** You may need to adjust some Input Keys in Open WebUI’s ComfyUI Workflow Nodes to match your workflow’s node IDs (e.g., rename seed to noise_seed).

**Tip:** Workflows utilizing Flux models may require multiple node IDs. Separate these IDs with commas in the node entry field (e.g., 1 or 1, 2).

Click `Save` to apply the settings and start generating images with ComfyUI in Open WebUI!

### FLUX.1 Model Setup

1. Download Model Checkpoints: Download either the FLUX.1-schnell or FLUX.1-dev model from the Black Forest Labs HuggingFace page.
1. Place the model checkpoints in both the models/checkpoints and models/unet directories in ComfyUI. Alternatively, you can create a symbolic link between the two directories.
1. VAE Model: Download the ae.safetensors VAE and place it in the models/vae directory.
1. CLIP Model: Download the clip_l.safetensors file and place it in the models/clip directory.
1. T5XXL Model: Download either the t5xxl_fp16.safetensors or t5xxl_fp8_e4m3fn.safetensors model and place it in the models/clip directory.

By completing these steps, you’ll have successfully integrated ComfyUI with Open WebUI, enabling the use of FLUX.1 models for image generation.

## See also

- [Ubuntu 26.04 GPU Setup](https://ubuntu.fan/en/docs/ai/gpu-setup)
- [Ollama](https://ollama.com)
  - [Ollama documentation](https://docs.ollama.com)
  - [Ollama API reference](https://docs.ollama.com/api/introduction)
  - [Ollama models](https://ollama.com/search)
  - [Securely Exposing Ollama Service](https://dev.to/baboon/securely-exposing-ollama-service-to-the-public-internetcomplete-deployment-and-remote-management-59nn)
- [vLLM](https://vllm.ai)
  - [vLLM Quick Start Guide](https://docs.vllm.ai/en/stable/getting_started/quickstart)
  - [Install vLLM on Ubuntu Linux for Production](https://computingforgeeks.com/install-vllm-linux-production)
- [Ollama vs vLLM](https://medium.com/@mustafa.gencc94/ollama-vs-vllm-a-comprehensive-guide-to-local-llm-serving-91705ec50c1d) (Medium article)
- [Claude](https://claude.ai)
  - [Claude Code Quickstart](https://code.claude.com/docs/en/quickstart)
  - [Building custom Claude connectors](https://claude.com/docs/connectors/building)
  - [Open WebUI Claude Code Pipe](https://github.com/tfriedel/openwebui-claude-code)
- [OpenClaw](https://openclaw.ai)
  - [Connect OpenClaw to Open WebUI](https://docs.openwebui.com/getting-started/quick-start/connect-an-agent/openclaw)
  - [Hardening OpenClaw](https://docs.openclaw.ai/security)
  - [OpenClaw Github repository](https://github.com/openclaw/openclaw)
- [Running LLMs Locally - Ollama + MCP](https://youtu.be/GAyNvq6Ayps) (YouTube video)
- [Awesome Free Models](https://github.com/12britz/awesome-free-models)
- [WrenAI documentation](https://docs.getwren.ai/oss/introduction)
- [ComfyUI Workflow Examples](https://comfyui-wiki.com/en/workflows)
- [Good How-To on local setup](https://medium.com/@luongnv89/how-to-run-claude-code-codex-with-local-models-via-llamacpp-ollama-lmstudio-and-vllm-2026-7d00ba7e63a4) (Medium article)
