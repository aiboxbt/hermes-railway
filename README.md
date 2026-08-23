# Hermes Agent — Railway Deploy Template

> Minimal Railway-ready template for deploying **Hermes Agent** (NousResearch/hermes-agent) using the official Docker image with s6-overlay supervision.

---

## 📦 What's in this repo

| File | Purpose |
|------|---------|
| `Dockerfile` | `FROM nousresearch/hermes-agent:v2026.8.3` + copies `start.sh` |
| `start.sh` | Starts gateway under s6 (`hermes gateway run`) + keeps container alive |
| `railway.toml` | Railway config: Dockerfile builder, `restartPolicyType = "always"` |
| `TEMPLATE_DESCRIPTION.md` | Original template documentation from Shinyduo |

---

## 🧬 Lineage

| Repo | Role |
|------|------|
| **NousResearch/hermes-agent** (forked to **aiboxbt/hermes-agent**) | Upstream source — full agent codebase, skills, CLI, gateway, WebUI |
| **Shinyduo/hermes-agent** | Original Railway template (4 files above) |
| **aiboxbt/hermes-railway** (this repo) | Your personal deploy repo — combines both |

---

## 🚀 Quick Deploy

### Option A: Railway one-click (using this repo as template)
1. Fork this repo to your GitHub
2. Click **Deploy on Railway** or `railway init --from-template aiboxbt/hermes-railway`

### Option B: CLI (what we did)
```bash
railway init --name hermes-cloud
railway up
railway domain --service hermes-cloud
```

---

## ⚙️ Required Environment Variables (set in Railway Console → Variables)

| Variable | Required | Example |
|----------|----------|---------|
| `HERMES_DASHBOARD_BASIC_AUTH_USERNAME` | ✅ | `admin` |
| `HERMES_DASHBOARD_BASIC_AUTH_PASSWORD` | ✅ | **change this!** |
| `HERMES_DASHBOARD` | ✅ | `1` |
| `HERMES_DASHBOARD_HOST` | ✅ | `0.0.0.0` |
| `HERMES_DASHBOARD_PORT` | ✅ | `8080` |
| `TELEGRAM_BOT_TOKEN` | If using Telegram | `123456:ABC...` |
| `TELEGRAM_ALLOWED_USERS` | If using Telegram | `5763405186` |
| `GATEWAY_ALLOW_ALL_USERS` | Optional | `false` |

> LLM API keys (OpenRouter, Anthropic, OpenAI, etc.) are configured **inside the WebUI** after first login (Settings → Model).

---

## 🔗 Links

- **Upstream (NousResearch):** https://github.com/NousResearch/hermes-agent
- **My Fork:** https://github.com/aiboxbt/hermes-agent
- **Railway Template (Shinyduo):** https://github.com/Shinyduo/hermes-agent
- **Railway Deploy Page:** https://railway.com/deploy/hermes-agent-updated-aug-26--hermes
- **Live Demo:** https://hermes-cloud-production-33ba.up.railway.app (login: `admin` / password set in env)

---

## 📄 License

MIT — same as NousResearch/hermes-agent. Template files from Shinyduo/hermes-agent.