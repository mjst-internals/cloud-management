# cloud-management

**Tiny scripts for cloud management - just enough to save time, not enough to build Skynet.**

This repo contains lightweight utilities to handle common cloud tasks with minimal effort.  
Think of it as your personal DevOps toolbox — no frameworks, no overengineering, just scripts that get stuff done.

---

## 🔧 Features

- Misc scripts to smooth over daily ops

---

## 🧱 Stack

- Shell scripts (Bash or PowerShell)
- Cloud provider CLIs (e.g. `doctl`, `aws`, `gcloud`, `cloudflare`, `hcloud`)

> ⚠️ No magic here — bring your own API keys, permissions, and caffeine.

---

## 📁 Structure

scripts/<br>
├─ powershell/ `# on Windows`<br>
├─ bash/ `# on Unix/Linux`<br>

---

## 🧠 Philosophy

This isn't a framework. It's a collection of small tools and config snippets that:
- Save time
- Reduce human error
- Are actually understandable after 3 weeks

---

## 🚀 Getting Started

Clone the repo, skim the scripts, customize to your needs.

```bash
git clone https://github.com/mjst-internals/cloud-management.git
cd cloud-management

have-fun
```

As an alternative, you can checkout one script-path only:

```bash
git clone --filter=blob:none --no-checkout https://github.com/mjst-internals/cloud-management.git
cd cloud-management

git sparse-checkout init --cone
git sparse-checkout set scripts/powershell
git sparse-checkout set scripts/bash

have-fun
```

---

## 🛡️ Disclaimer

This repo will not deploy Kubernetes clusters, optimize costs, or fix your cloud bill.<br>
It will help you avoid clicking through web UIs at 2 AM.

--- 

## 📬 Feedback

Found a bug? Got a better idea?<br>
Open an issue or hit me up — PRs are welcome, sarcasm optional.
