# 🌐 NetQueryBot — Networking Chatbot

A Streamlit chatbot specialized exclusively in computer networking, powered by Groq's `llama-3.1-8b-instant` model.

## Overview

NetQueryBot answers questions about networking topics — OSI model, TCP/IP, subnetting, routing protocols (OSPF, BGP, EIGRP, RIP), switching (VLANs, STP), network security, DNS/DHCP/NAT, troubleshooting tools, wireless standards, cloud networking, and CCNA/Network+ certification prep — and politely redirects anything outside that scope. It's built with a system prompt that constrains the model to networking topics, and keeps conversation history for multi-turn context.

## Features

- Dark, GitHub-style chat UI built with custom CSS in Streamlit
- Sidebar with topic badges and clickable sample questions
- Running question counter and model indicator
- "Clear Chat" to reset the conversation

## Setup

```bash
pip install -r requirements.txt
```

Create a `.env` file (see `.env.example`) with your own [Groq API key](https://console.groq.com/keys):

```
GROQ_API_KEY=your_groq_api_key_here
```

Then run:

```bash
streamlit run app.py
```

## Files

| File | Description |
|---|---|
| `app.py` | Streamlit chatbot app |
| `requirements.txt` | Python dependencies |
| `.env.example` | Template for the required `GROQ_API_KEY` — copy to `.env` and fill in your own key |
