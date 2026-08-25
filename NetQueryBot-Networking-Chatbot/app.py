import streamlit as st
from dotenv import load_dotenv
from groq import Groq
import os

# Load environment variables
load_dotenv()

# ─────────────────────────────────────────────
# Page Configuration
# ─────────────────────────────────────────────
st.set_page_config(
    page_title="NetQueryBot",
    page_icon="🌐",
    layout="wide",
    initial_sidebar_state="expanded"
)

# ─────────────────────────────────────────────
# Custom CSS
# ─────────────────────────────────────────────
st.markdown("""
<style>
    .stApp { background-color: #0d1117; color: #e6edf3; }
    [data-testid="stSidebar"] { background-color: #161b22; border-right: 1px solid #30363d; }
    .user-msg {
        background: linear-gradient(135deg, #1f4e8c, #1a6fd4);
        color: white; padding: 12px 18px;
        border-radius: 18px 18px 4px 18px;
        margin: 8px 0; max-width: 80%; margin-left: auto;
        font-size: 15px; box-shadow: 0 2px 8px rgba(26,111,212,0.3);
    }
    .bot-msg {
        background-color: #161b22; color: #e6edf3;
        padding: 12px 18px; border-radius: 18px 18px 18px 4px;
        margin: 8px 0; max-width: 85%; font-size: 15px;
        border: 1px solid #30363d; box-shadow: 0 2px 8px rgba(0,0,0,0.3);
    }
    .header-box {
        background: linear-gradient(135deg, #0d1b2a, #1a3a5c);
        padding: 20px 28px; border-radius: 12px;
        border: 1px solid #1f4e8c; margin-bottom: 20px; text-align: center;
    }
    .topic-badge {
        display: inline-block; background-color: #1f3a5c; color: #58a6ff;
        padding: 4px 12px; border-radius: 20px; font-size: 12px;
        margin: 3px; border: 1px solid #1a6fd4;
    }
    .stTextInput > div > div > input {
        background-color: #161b22; color: #e6edf3;
        border: 1px solid #30363d; border-radius: 10px;
    }
    .stButton > button {
        background: linear-gradient(135deg, #1a6fd4, #1f4e8c);
        color: white; border: none; border-radius: 10px;
        padding: 10px 24px; font-weight: 600; width: 100%;
    }
    .stButton > button:hover { background: linear-gradient(135deg, #2280e8, #1a6fd4); }
    hr { border-color: #30363d; }
    [data-testid="metric-container"] {
        background-color: #161b22; border: 1px solid #30363d;
        border-radius: 10px; padding: 10px;
    }
</style>
""", unsafe_allow_html=True)

# ─────────────────────────────────────────────
# System Prompt
# ─────────────────────────────────────────────
SYSTEM_PROMPT = """You are NetQueryBot, an expert AI assistant specialized exclusively in Computer Networking.

You have deep knowledge in:
- OSI Model & TCP/IP Stack
- IP Addressing & Subnetting (IPv4 & IPv6)
- Routing Protocols: OSPF, BGP, EIGRP, RIP
- Switching: VLANs, STP, EtherChannel
- Network Security: Firewalls, ACLs, VPN, IDS/IPS
- DNS, DHCP, NAT, HTTP/HTTPS
- Network Troubleshooting & Tools (ping, traceroute, Wireshark)
- Wireless Networking (Wi-Fi standards, WPA)
- Cloud Networking (AWS VPC, Azure VNet)
- Certification Topics: CCNA, CompTIA Network+

Rules:
- Answer ONLY networking-related questions.
- If asked about unrelated topics, politely redirect to networking.
- Use clear explanations with examples where helpful.
- For technical answers, use bullet points and structured formatting.
- Mention relevant commands (Cisco IOS, Linux) when applicable.
- Always be beginner-friendly while staying technically accurate.
"""

# ─────────────────────────────────────────────
# Groq Client
# ─────────────────────────────────────────────
@st.cache_resource
def get_client():
    return Groq(api_key=os.getenv("GROQ_API_KEY"))

def get_response(user_input, chat_history):
    client = get_client()

    messages = [{"role": "system", "content": SYSTEM_PROMPT}]
    messages.extend(chat_history)
    messages.append({"role": "user", "content": user_input})

    response = client.chat.completions.create(
        model="llama-3.1-8b-instant",
        messages=messages,
        temperature=0.4,
        max_tokens=1024
    )
    return response.choices[0].message.content

# ─────────────────────────────────────────────
# Session State
# ─────────────────────────────────────────────
if "messages" not in st.session_state:
    st.session_state.messages = []
if "chat_history" not in st.session_state:
    st.session_state.chat_history = []
if "question_count" not in st.session_state:
    st.session_state.question_count = 0

# ─────────────────────────────────────────────
# Sidebar
# ─────────────────────────────────────────────
with st.sidebar:
    st.markdown("## 🌐 NetQueryBot")
    st.markdown("*AI-Powered Networking Q&A Assistant*")
    st.divider()

    st.markdown("### 📚 Topics Covered")
    topics = [
        "OSI Model", "TCP/IP", "Subnetting", "OSPF", "BGP",
        "VLANs", "STP", "DNS & DHCP", "Firewalls", "VPN",
        "IPv4 & IPv6", "NAT", "Wireshark", "CCNA Prep", "CompTIA Net+"
    ]
    badge_html = "".join([f'<span class="topic-badge">{t}</span>' for t in topics])
    st.markdown(badge_html, unsafe_allow_html=True)

    st.divider()
    st.markdown("### 💡 Sample Questions")
    samples = [
        "What is the OSI model?",
        "Explain subnetting with example",
        "How does OSPF work?",
        "Difference between TCP and UDP?",
        "What is a VLAN and why use it?",
        "How does DNS resolve a domain?",
        "What is BGP used for?",
    ]
    for q in samples:
        if st.button(q, key=q):
            st.session_state["prefill"] = q

    st.divider()
    col1, col2 = st.columns(2)
    with col1:
        st.metric("💬 Questions", st.session_state.question_count)
    with col2:
        st.metric("🧠 Model", "Llama3-8B")

    if st.button("🗑️ Clear Chat"):
        st.session_state.messages = []
        st.session_state.chat_history = []
        st.session_state.question_count = 0
        st.rerun()

# ─────────────────────────────────────────────
# Main Header
# ─────────────────────────────────────────────
st.markdown("""
<div class="header-box">
    <h1 style="color:#58a6ff; margin:0; font-size:2rem;">🌐 NetQueryBot</h1>
    <p style="color:#8b949e; margin:6px 0 0;">AI-Powered Networking Q&A Assistant</p>
    <p style="color:#58a6ff; font-size:13px; margin-top:4px;">Ask anything about Networking · CCNA · TCP/IP · Subnetting · Routing · Security</p>
</div>
""", unsafe_allow_html=True)

# ─────────────────────────────────────────────
# Chat Display
# ─────────────────────────────────────────────
if not st.session_state.messages:
    st.markdown("""
    <div style="text-align:center; padding:40px; color:#8b949e;">
        <h3 style="color:#58a6ff;">👋 Welcome to NetQueryBot!</h3>
        <p>I'm your AI networking expert. Ask me anything about:</p>
        <p>🔹 OSI & TCP/IP &nbsp;|&nbsp; 🔹 Routing & Switching &nbsp;|&nbsp; 🔹 Subnetting</p>
        <p>🔹 Network Security &nbsp;|&nbsp; 🔹 CCNA Prep &nbsp;|&nbsp; 🔹 Troubleshooting</p>
    </div>
    """, unsafe_allow_html=True)
else:
    for msg in st.session_state.messages:
        if msg["role"] == "user":
            st.markdown(f'<div class="user-msg">🧑‍💻 {msg["content"]}</div>', unsafe_allow_html=True)
        else:
            st.markdown(f'<div class="bot-msg">🌐 <b>NetQueryBot</b><br><br>{msg["content"]}</div>', unsafe_allow_html=True)

# ─────────────────────────────────────────────
# Input Area
# ─────────────────────────────────────────────
st.divider()
prefill_value = st.session_state.pop("prefill", "")

with st.form(key="chat_form", clear_on_submit=True):
    col1, col2 = st.columns([5, 1])
    with col1:
        user_input = st.text_input(
            label="Ask a networking question...",
            value=prefill_value,
            placeholder="e.g. What is the difference between TCP and UDP?",
            label_visibility="collapsed"
        )
    with col2:
        submitted = st.form_submit_button("Send 🚀")

if submitted and user_input.strip():
    st.session_state.messages.append({"role": "user", "content": user_input})
    st.session_state.question_count += 1

    with st.spinner("🌐 NetQueryBot is thinking..."):
        try:
            bot_reply = get_response(user_input, st.session_state.chat_history)
            st.session_state.chat_history.append({"role": "user", "content": user_input})
            st.session_state.chat_history.append({"role": "assistant", "content": bot_reply})
        except Exception as e:
            bot_reply = f"⚠️ Error: {str(e)}\n\nPlease check your GROQ_API_KEY in the `.env` file."

    st.session_state.messages.append({"role": "assistant", "content": bot_reply})
    st.rerun()
