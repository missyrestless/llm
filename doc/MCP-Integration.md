# MCP Integration with a Local LLM

In order to integrate `Ollama` with MCP a bridge (client) is required. Several exist, we use
the MCP client for `ollama` at https://github.com/jonigl/mcp-client-for-ollama

**[Note:]** the `ollmcp` Ollama MCP client is installed as part of the Pip packages installed
by the `install` script in this repository.

## Table of Contents

- [Introduction](#introduction)
- [Example deployment of MCP with a local LLM](#example-deployment-of-mcp-with-a-local-llm)
  - [Getting started](#getting-started)
  - [Implement the tools](#implement-the-tools)
  - [Create an MCP client](#create-an-mcp-client)
  - [Utility functions](#utility-functions)

## Introduction

The `ollmcp` Ollama MCP client can be used to connect to your MCP server with a script like:

```bash
#!/bin/bash

MCP_SERVER_URL="https://mcp.server.domain/api/v1/connect"
MCP_TOKEN="<yoursecretauthtoken>"

ollmcp --mcp-server-url "${MCP_SERVER_URL}?token=${MCP_TOKEN}" --model "qwen3.5:9b"
```

Several packages are available to provide programmatic abstraction and convenience when
making requests to your Ollama/MCP integrated setup. For example, the `Langchain` Python
packages `langchain-mcp-adapters`, `langchain-ollama`, and `langgraph` may be of interest.

## Example deployment of MCP with a local LLM

Any large language model that supports function calling (or tool use) is capable of making use of the model context protocol. In this section, we’ll start by creating an MCP server that offers a few tools, and then get a small Llama 3.2 model to make use of those tools.

See the [Understanding Model Context Protocol (MCP)](https://medium.com/predict/understanding-model-context-protocol-mcp-771f1cfb3c0a) Medium article to get familiar with MCP.

### Getting started

This example MCP server will offer three tools: `ls` to list the contents of a directory, `cat` to read the contents of a file, and `echo` to write something to a file.

Start by installing the mcp library using pip:

```bash
pip install mcp
pip list | grep mcp

# Output:
# mcp    1.5.0
```

Call the MCP server "Local Agent Helper". It’s a decent name because our local LLM will be behaving like a simple agent once it can communicate with this server.

```python
from mcp.server.fastmcp import FastMCP

server = FastMCP("Local Agent Helper")
```

### Implement the tools

Next, implement the three tools. This example uses platform-independent code, but Python's subprocess module could be used to spawn the ls, cat, and echo commands on Mac OS or Linux.

```python
@server.tool()
def ls(directory: str) -> str:
    "List the contents of a directory."
    import os
    return "\n".join(os.listdir(directory))

@server.tool()
def cat(file: str) -> str:
    "Read the contents of a file."
    try:
        with open(file, "r") as f:
            return f.read()
    except:
        return ""

@server.tool()
def echo(message: str, file: str) -> str:
    "Write text to a file."
    try:
        with open(file, "w") as f:
            f.write(message)
            return "success"
    except:
        return "failed"
```

Use the MCP inspector to test if your server is behaving the way it should.

### Create an MCP client

This client will also be running the LLM. This example uses the Llama 3.2–1B-Instruct model. If your setup has more memory, consider using a larger model.

To understand function calling in LLMs, see the [Medium article about function calling](https://medium.com/@hathibel/function-calling-in-llms-bec37cb48d63).

Use HuggingFace’s transformers library to load the model and run inference on it:

```python
from transformers import AutoTokenizer, AutoModelForCausalLM

model = "meta-llama/Llama-3.2-1b-instruct"

tokenizer = AutoTokenizer.from_pretrained(model)
model = AutoModelForCausalLM.from_pretrained(model)
```

Communicate with the MCP server using standard input and output. Spawn the server as a process. For all complex interactions, using Popen() instead of run(), is conventional wisdom, so this is how we start the server:

```python
import subprocess

server = subprocess.Popen(
    ['python3', 'server.py'],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    stdin=subprocess.PIPE,
    text=True,
)
```

### Utility functions

The base MCP protocol involves creating, sending, and receiving JSON-RPC messages. Create some utility functions for them.

```python
import json
def create_message(method_name, params, id = None):
    message = {
        "jsonrpc": "2.0",
        "method": method_name,
        "params": params,
        "id": id
    }
    return json.dumps(message)

def send_message(message):
    server.stdin.write(message + "\n")
    server.stdin.flush()

def receive_message():
    server_output = json.loads(server.stdout.readline())
    if "result" in server_output:
        return server_output["result"]
    else:
        return "Error"
```

According to the protocol, the first message we need to send is an initialization message, which starts our client’s conversation with the MCP server. In this message the client just introduces itself to the server, specifying its name and version. The name of the MCP method for this step is `initialize`.

The server will reply introducing itself, giving various details about its capabilities.

To say that the initialization is complete, we need to call a method named `notifications/initialized`.
This doesn’t need any parameters, and the server won’t reply back this time.

The following code shows how to initialize a communication session:

```python
id = 1
init_message = create_message(
    "initialize",
    {
        "clientInfo": {
            "name": "Llama Agent",
            "version": "0.1"
        },
        "protocolVersion": "2024-11-05",
        "capabilities": {},
    },
    id
)

send_message(init_message)
response = receive_message()
server_name = response["serverInfo"]["name"]
print("Initializing  " + server_name + "...")

init_complete_message = create_message("notifications/initialized", {})
send_message(init_complete_message)
print("Initialization complete.")

# Output:
# Initializing  Local Agent Helper...
# Initialization complete.
```

With function calling, we pass an array of tools to the LLM. Get the array of tools from our MCP server. To do so, we need to use the `tools/list` method:

```python
id += 1
list_tools_message = create_message("tools/list", {}, id)
send_message(list_tools_message)
response = json.loads(server.stdout.readline())["result"]
for tool in response["tools"]:
    print(tool["name"])
    print(tool["description"])
    print(tool["inputSchema"]["properties"])
    print("")

# Output:
# ls
# List the contents of a directory.
# {'directory': {'title': 'Directory', 'type': 'string'}}
#
# cat
# Read the contents of a file.
# {'file': {'title': 'File', 'type': 'string'}}
#
# echo
# Write text to a file.
# {'message': {'title': 'Message', 'type': 'string'},
# 'file': {'title': 'File', 'type': 'string'}}
```

Use the MCP server details to create the tools array:

```python
available_functions = []
for tool in response["tools"]:
    func = {
        "type": "function",
        "function": {
            "name": tool["name"],
            "description": tool["description"],
            "parameters": {
                "type": "object",
                "properties": tool["inputSchema"]["properties"],
                "required": tool["inputSchema"]["required"],
            },
        },
    }
    available_functions.append(func)
```

At this point, the available_functions array contains all the tools in a format our Llama model can read and easily use. For example, if we send a prompt like “What‘s there in the /tmp directory?”, Llama should be able to guess that it needs to use the ls tool and call it correctly.

We’ll need a chat template to concatenate the prompt and the array of tools into a single input sequence that can be tokenized:

```python
prompt = "What's there in the /tmp directory?"

messages = [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": prompt},
]

template = tokenizer.apply_chat_template(
    messages, tools=available_functions,
    tokenize=False
)

inputs = tokenizer(template, return_tensors="pt")
```

And finally, we can pass the tokens to the model. This has almost become a drill, and needs no explanation:

```python
inputs = tokenizer(template, return_tensors="pt")
outputs = model.generate(**inputs, max_new_tokens=30, do_sample=True)
print(tokenizer.decode(outputs[0]))

# Output:
# What's there in the /tmp directory?<|eot_id|>
# <|start_header_id|>assistant<|end_header_id|>
# <|python_tag|>{"type": "function", "function":
# "ls", "parameters": {"directory": "/tmp"}}
# <|eom_id|>
```

Llama 3.2 1B-Instruct almost always manages to get the function calls right. It’s a small model, but still very smart. You can see that the function call starts with <|python_tag|> and ends with <|eom_id|>. So we need to extract the JSON string between those tags and convert it into a JSON-RPC message we can send to the MCP server.

```python
last_line = generated_text.split("\n")[-1]
start_marker = "<|python_tag|>"
end_marker = "<|eom_id|>"
id += 1
if start_marker in last_line and end_marker in last_line:
    code = last_line.split(start_marker)[1].split(end_marker)[0]
    code = json.loads(code)
    function_call = create_message("tools/call", {
        "name": code["function"],
        "arguments": code["parameters"],
    }, id)
    send_message(function_call)
    response = receive_message()["content"][0]["text"]

# Output:
# tmp1.html
# tmp2.html
```

If everything went right, the MCP server’s response should contain the contents of the directory.
