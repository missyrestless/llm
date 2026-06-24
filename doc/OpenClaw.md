# OpenClaw

Installing and configuring OpenClaw—an autonomous AI agent that runs on your hardware and connects to messaging apps—takes just a few minutes. Because the agent can operate tools and manage your data, setting it up securely (preferably on a Virtual Private Server (VPS)) is highly recommended.

## Install the CLI and Daemon 

The fastest way to install OpenClaw is using the official automated script, which detects your operating system and installs Node.js if needed. 

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

## Run the Onboarding Wizard 

Once installed, initiate the onboarding wizard to generate your configuration files, create an authentication token, and set up your agent's background service. 

1. Run this command in your terminal: `openclaw onboard --install-daemon`
2. Gateway Password: Create a strong gateway password when prompted. 
3. Bind Mode: Select localhost for initial testing. 
4. API Keys: You will be prompted to paste an API key from an AI model provider like OpenAI or Anthropic. 
5. Gateway Token: The installer will generate a Gateway Token. Copy this securely as you will need it to access your Web Dashboard.

### Verify the Gateway is running

```bash
openclaw gateway status
```

## Configure Communication Channels 

OpenClaw is designed to be interacted with via chat apps like Telegram or WhatsApp. To set up a Telegram bot: 

1. Open Telegram and search for `BotFather`. 
2. Send the command `/newbot` and follow the prompts to name your bot. 
3. Copy the unique bot token provided by BotFather. 
4. Open the OpenClaw Dashboard and paste this bot token into your channel configuration, then pair the chat by starting a conversation with your new bot on Telegram. [8, 9, 10, 11]  

## Install Skills and Apply Security Guardrails 

OpenClaw’s capabilities can be significantly expanded using "skills" (such as Google Workspace, Slack, or web browsing tools). 

- To install a skill: Ask your OpenClaw agent directly via chat to install a skill (e.g., "Install the Google Workspace skill") or provide a GitHub link. 
- Security & Guardrails: To protect your system, ask OpenClaw to implement recommended security settings by pasting the security documentation checklist into your chat and asking the AI to "Implement and verify everything on this page (leave allow insecure auth set to true)". [8]  

## References

- https://www.youtube.com/watch?v=BoC5MY_7aDk&vl=en-US
- https://www.youtube.com/watch?v=u4ydH-QvPeg
- https://ollama.com/blog/openclaw-tutorial
- https://www.youtube.com/watch?v=OrOMVca-ht8
- https://docs.openclaw.ai/install
- https://shawnkanungo.com/blog/how-to-install-and-configure-openclaw-on-your-device
- https://docs.openclaw.ai/start/getting-started
- https://www.youtube.com/watch?v=WDHgibiZ9S8
- https://flypix.ai/openclaw-setup-guide/
- https://www.c-sharpcorner.com/article/the-complete-guide-to-integrating-telegram-with-openclaw-2026-the-steps-most/
- https://www.youtube.com/watch?v=16TDhubye98
