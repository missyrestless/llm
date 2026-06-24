# Open WebUI Workspace Models

In Open WebUI, Workspace Models (also known as Custom Models or Agents) are
customized wrappers built on top of your base language models. They allow you
to bundle specific instructions, specialized system prompts, advanced parameters,
tools, and native knowledge bases into a standalone, reusable agent.

Instead of configuring settings every time you start a new chat, you can select
your pre-configured Workspace Model from the main dropdown menu.

## Table of Contents

- [Key Capabilities of Workspace Models](#key-capabilities-of-workspace-models)
- [How to Create and Configure a Workspace Model](#how-to-create-and-configure-a-workspace-model)
- [Access Control and Distribution](#access-control-and-distribution)
- [Open WebUI REST API](#open-webui-rest-api)
- [Verify and List Configured Models](#verify-and-list-configured-models)
- [Crucial Tips for Automation and CI/CD](#crucial-tips-for-automation-and-ci/cd)
- [References](#references)

## Key Capabilities of Workspace Models

- System Prompts & Personas: You can hardcode a specific behavior, tone, or role (e.g., a "Python Tutor" or "Legal Assistant") so the underlying LLM always adheres to those rules.
- Knowledge Integration (RAG): You can permanently link Open WebUI Knowledge Bases (uploaded PDFs, corporate documents, or text files) to a specific model so it always references that data without requiring manual document attachments in chat.
- Default Tools & Skills: You can assign specific functions or plugins (like web search engines, calculators, or Python execution environments) to activate automatically whenever that model is used.
- Advanced Hyperparameters: You can lock in custom model parameters (such as , , or ) directly at the model level to control creativity and response length.

## How to Create and Configure a Workspace Model

- Access the Workspace Menu
  - Click `Workspace` in the Open WebUI left-hand sidebar
  - Select the `Models` tab
  - Click `Create a Model` (or click the edit icon on an existing custom model)
- Fill in the Base Configuration
  - Name &amp; Description: Give your model a consumer-facing name (e.g., Company Document Summarizer)
  - Base Model: Select the underlying foundational model powering this agent
- Attach Prompts, Knowledge, and Extensibility
  - System Prompt: Input the core instructions guiding your agent
  - Knowledge Source: Use the dropdown menu to link a pre-created knowledge collection
  - Tools / Skills: Check the boxes for the custom community tools or capabilities you want the model to use
  - Save: Scroll to the bottom and click `Save` or `Create`

## Access Control and Distribution

If you are an administrator, Workspace Models serve as a powerful tool for restricting and organizing user access.

- Cloning: You can take a raw API base model, clone it, rename it, lock down the base model to "Private" for admin eyes only, and distribute the custom clone to your users.
- Visibility: Set a workspace model to Public to make it available to all active instances, or restrict it to specific User Groups so only designated teams can see and interact with it.

## Open WebUI REST API

Open WebUI workspace models can be created and updated using the Open WebUI REST API.

For example, to register a brand new customized workspace model, send a POST request
to the `/api/v1/models/create` endpoint.

### Create Workspace Model Endpoint

```
POST https://openwebui.neoman.dev/api/v1/models/create
```

### Create Workspace Model Payload Example

```json
{
  "id": "custom-support-agent",
  "name": "Customer Support Agent",
  "base_model_id": "gpt-4o-mini",
  "meta": {
    "description": "A customized workspace model tailored for support tickets.",
    "capabilities": {
      "vision": true
    }
  },
  "params": {
    "system": "You are a professional customer support assistant. Be polite, concise, and do not make up facts.",
    "temperature": 0.3,
    "top_p": 0.9,
    "max_tokens": 1000
  }
}
```

### Update Workspace Model Endpoint

To modify parameters (such as updating the system prompt or tuning hyperparameters),
issue a POST request to the update endpoint.

```
POST https://openwebui.neoman.dev/api/v1/models/update
```

### Update Workspace Model Payload Example

```json
{
  "id": "custom-support-agent",
  "name": "Customer Support Agent v2",
  "base_model_id": "gpt-4o-mini",
  "meta": {
    "description": "Updated support model with localized phrasing context."
  },
  "params": {
    "system": "You are a professional support assistant. Greet the user warmly and solve their technical inquiry step-by-step.",
    "temperature": 0.2
  }
}
```

### Delete Workspace Model Endpoint

To delete a workspace model issue a POST request to the delete endpoint.

```
POST https://openwebui.neoman.dev/api/v1/models/delete
```

### Delete Workspace Model Payload Example

```json
{
  "id": "custom-support-agent"
}
```

## Verify and List Configured Models

To make sure your configuration persisted correctly or to fetch existing model specs,
you can read the model index:

- Get All Models: `GET https://openwebui.neoman.dev/api/v1/models`
- Get Single Model Details: `GET https://openwebui.neoman.dev/api/v1/models/model?id=custom-support-agent`

## Crucial Tips for Automation and CI/CD

- The id Gotcha: When creating a workspace model, the backend automatically sanitizes or maps the string. Use lowercase letters, numbers, or dashes for consistency across deployments.
- Access Permissions: By default, models created via the API inherit the visibility rules configured in your default settings. If non-admin users cannot see your new model, verify they have permission to access the underlying base_model_id.
- Interactive Endpoint Inspection: If your Open WebUI instance is running in a local development context, you can access the full interactive Swagger documentation at http://localhost:8080/docs to view up-to-the-minute property definitions.

## References

- https://docs.openwebui.com/features/
- https://www.youtube.com/watch?v=Fd_1zePgCLE
- https://docs.openwebui.com/
- https://medium.com/@able_wong/getting-started-with-local-ai-open-webui-documents-and-tools-part-2-5f8f9c67a414
- https://docs.openwebui.com/features/workspace/knowledge/
- https://railway.com/deploy/open-webui-2
- https://docs.openwebui.com/features/chat-conversations/chat-features/reasoning-models/
- https://inside.wpriders.com/ollama-webui-10-steps-to-free-private-ai/
- https://docs.openwebui.com/features/extensibility/plugin/tools/
- https://docs.openwebui.com/features/workspace/skills/
- https://docs.openwebui.com/features/chat-conversations/chat-features/reasoning-models/
- https://www.youtube.com/watch?v=lDyFzyD0TD0
- https://documentation.suse.com/suse-ai/1.0/html/openwebui-configuring/openwebui-managing-models.html
- https://docs.openwebui.com/features/workspace/models/
- https://www.youtube.com/watch?v=CDiVq3mPZc8
- https://www.youtube.com/watch?v=DhRvV5o6SCU
- https://help.anaplan.com/levels-of-model-access-44fec486-243d-4980-b7ae-60c7ab84f4c9
