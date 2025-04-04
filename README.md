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
├─ bash/ `# on Unix/Linux` (details see: [cm-scripts.md](https://github.com/mjst-internals/cloud-management/blob/ad8654a22e205cd00ecafb09f71aba204d9fafc8/docs/bash/cm-scripts.md)) <br>

---

## 🧠 Philosophy

This isn't a framework. It's a collection of small tools and config snippets that:
- Save time
- Reduce human error
- Are actually understandable after 3 weeks

---

## 🚀 Getting Started

### Downloading releases

#### Windows

coming soon... or maybe not 🤔

#### Linux

Simply copy the file [`cm-update-bash.sh`](https://github.com/mjst-internals/cloud-management/blob/badb39797b09c25fdc9476174fdd2c1af8cb3c7f/scripts/bash/cm-update-bash.sh) from [scripts/bash](https://github.com/mjst-internals/cloud-management/blob/badb39797b09c25fdc9476174fdd2c1af8cb3c7f/scripts/bash/) into your `$HOME` directory and execute it as `sudo`:

```bash
```  sudo bash ~/cm-update-bash.sh
```

#### Linux: Use cloud-maintenance as cloud-config

Paste the contents from the template file [cloud-config.yaml](https://github.com/mjst-internals/cloud-management/blob/badb39797b09c25fdc9476174fdd2c1af8cb3c7f/scripts/bash/templates/cloud-config.yaml) to the cloud-config section of your cloud-provider:

![image](https://github.com/user-attachments/assets/c09dc391-ec73-4c54-9434-bb707f8154f2)

### Cloning from source

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
