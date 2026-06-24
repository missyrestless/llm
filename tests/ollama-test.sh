#!/bin/bash
#
# Simple test to verify the Nginx reverse proxy is able to pass requests to Ollama
#
# Set these to the hostname, username, and password for the Nginx server 
HOST="your.nginx.com"
USER="your-username"
PASS='your-password'
# Set this to the model you wish to use [default: tinyllama]
MODEL="tinyllama"
#
# Test basic connection
curl -u ${USER}:${PASS} https://${HOST}/api/tags

echo ""
echo "----------------"
echo ""

# Test model conversation
curl -u ${USER}:${PASS} -X POST https://${HOST}/api/generate \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"${MODEL}\",
    \"prompt\": \"Hello, how are you?\",
    \"stream\": false
  }"
