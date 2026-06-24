# Ollama CLI Cheat Sheet

## Server Management

### Start ollama server using commands - start or serve
```bash
ollama start
ollama serve
```

### Check if server is running
```bash
ollama ps
ollama ps --verbose # Check system resources
```

### Check logs
```bash
ollama logs
```

### Clear model cache
```bash
ollama prune
```

### Reset ollama
```bash
rm -rf ~/.ollama
```

### Stop ollama server (Ctrl+C or kill process)


## Model Management

### List locally available models (ones that are pulled)
```bash
ollama list
```

### Pull/download a model from ollama registry (Refer https://ollama.com/models)
```bash
ollama pull qwen2.5:0.5b
ollama pull mistral:1b
ollama pull gemma3:1b
```

### Remove a model
```bash
ollama rm mistral:1b
```

### Show model information
```bash
ollama show gemma3:1b
ollama show gemma3:1b --verbose
```

### Copy a model
```bash
ollama cp qwen2.5:0.5b qwen2.5-mydev
```

### Run a model interactively
```bash
ollama run qwen2.5:0.5b
ollama run gemma3:1b
```
## Once the model is running in interactive mode

You could run the below commands:

```sh
>>> /? # Help
>>> /help # Help
>>> /set # set session variables
>>> /set parameter seed 13 # Random number seed  
>>> /set parameter num_predict 100 # max number of tokens to predict
>>> /set parameter top_k 3 # pick top k number of tokens
>>> /set parameter top_p 0.5 # pick tokens based on cumulative probabilities
>>> /set parameter min_p 0.1 # discard tokens below the threshold 
>>> /set parameter num_ctx 1024 # set context size
>>> /set parameter temparature 0.5 # set creative levels
>>> /set parameter stop stop_word1 stop_word2
>>> /set system prompt_message
>>> /set history # Note: This is not chat history, but user prompt history that you see in your prompt CLI as you press Up/Down arrows.
>>> /set nohistory # will not record the prompt messages sent to the model, after it is set so.
>>> /set format json
>>> /set noformat
>>> /set verbose # show LLM stats
>>> /set quiet # disable llm stats
>>> /show # show model information
>>> /show info # detials of this model
>>> /show license # show license info for this model
>>> /show modelfile # show Modelfile for this model
>>> /show parameters # show parameters for this model
>>> /show system # show system message
>>> /show template # show prompt template
>>> /clear # clear session context
>>> /bye # exit
>>> """Embed multi-line user prompt withing triple-quotes..
    and this should work out the magic."""
```

### Run with specific parameters
```bash
ollama run gemma3:1b --temperature 0.8 # more creative text generation
ollama run gemma3:1b --num-ctx 4096 # context length
```

### Exit interactive mode
```bash
/bye
```

### Single prompt (non-interactive)
```bash
ollama generate qwen2.5:0.5b "Explain quantum computing"
```
### Generate with specific format
```bash
ollama generate qwen2.5:0.5b "Write a JSON response" --format json
```

### Chat with streaming
```bash
ollama run qwen2.5:0.5b --stream
```


## System and Configuration

### Check ollama version
```bash
ollama version
```

### Set environment variables
```bash
export OLLAMA_HOST=0.0.0.0:11434
export OLLAMA_MODELS=/path/to/models
```

### Update ollama (In windows, you get a prompt to update automatially when an update is available.)
```bash
curl -fsSL https://ollama.com/install.sh | sh
```


## API Usage via CLI

### Generate via API
Use with curl
```bash
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model": "llama2", "prompt": "Hello world"}'
```

### Chat via API
```bash
curl http://localhost:11434/api/chat -d '{
  "model": "llama2",
  "messages": [{"role": "user", "content": "Hello"}]
}'
```

### List models via API
```bash
curl http://localhost:11434/api/tags
```

## Model Creation

### Basic Modelfile
```bash
FROM qwen2.5:0.5b
PARAMETER temperature 0.8
PARAMETER num_ctx 4096
SYSTEM "You are a smart and focussed AI Agent."
```

### Create custom model from Modelfile
```bash
ollama create myagentmodel -f ./Modelfile
```
