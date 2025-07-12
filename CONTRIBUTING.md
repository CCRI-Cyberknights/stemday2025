# 🌟 `stemday2025` Contributor Guide (Admin-Only)

Welcome to the **CCRI CyberKnights STEM Day VM Project!** 🎉  
This repository powers a custom **Parrot Linux Capture The Flag (CTF)** experience for high school students.  

👥 **This repo is for CCRI CyberKnights club members only.**  
It contains all the source files, admin tools, and workflows for building and maintaining the **student-facing bundle**.  

📝 **Note:** Students will later receive a **separate public bundle** containing only the CTF challenges and launcher, without any admin tools or scripts.  

---

## 🗂️ Project Structure (Admin Repo)

```
Desktop/
├── CCRI_CTF/                     # Main CTF folder (admin/dev version)
│   ├── challenges/               # Interactive CTF challenges (source)
│   ├── web_version/              # Student-facing web portal (auto-generated)
│   ├── web_version_admin/        # Admin-only tools and templates
│   ├── Launch CCRI CTF Hub.desktop # Shortcut to launch the student hub
│   ├── (various admin scripts)   # Tools for flag generation and testing
│   ├── README.md                 # Project documentation
│   └── CONTRIBUTING.md           # Collaboration guide for club members
└── (etc.)                        # Misc admin/dev tools and assets
```

In the **student VM**, only these will be visible:  

```
Desktop/
├── CCRI_CTF/                     # Student bundle (built from this repo)
│   ├── challenges/               # Interactive CTF challenges
│   ├── web_version/              # Student-facing web portal (ready-to-use)
│   ├── Launch CCRI CTF Hub.desktop # Shortcut to launch the student hub
└── (no admin scripts)
```

---

## 🚀 Joining the Repo

If you’re a CCRI CyberKnights member and want to contribute:  

1. Contact **Tolgar (Corey)** on Discord with your GitHub username.  
2. Corey will invite you to the **CCRI-Cyberknights GitHub organization**.  
3. Accept the invitation from your GitHub notifications or email.  
4. Once added, you’ll have collaborator access to this repo.  

---

## 🧑‍💻 Setting Up Your Environment (Admin VM)

### ✅ Install Git & Prerequisites

Run this single command to auto-detect your distro and install the required tools:  

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/CCRI-Cyberknights/stemday2025/main/setup_dev_env.sh)"
```

This script supports **Parrot OS**, **Debian**, **Ubuntu**, and **Linux Mint**.  
If you’re on another Linux distro (e.g., Arch or Fedora), install the equivalent packages manually:  

- `git python3 python3-pip python3-venv`
- `python3-markdown python3-scapy`
- `exiftool zbar-tools steghide hashcat unzip nmap tshark`

If you want to run `tshark` without `sudo`, add your user to the `wireshark` group:  

```bash
sudo usermod -aG wireshark $USER
# Log out and back in for group changes to take effect
```
## 🛠 Admin Workflow

### 📥 Clone the Repo

If you're not using **Parrot OS**, make sure Git is installed before cloning.  

```bash
# Install Git if necessary
sudo apt update && sudo apt install -y git
```

Then clone the repo:  

```bash
git clone https://github.com/CCRI-Cyberknights/stemday2025.git
cd stemday2025
```

### 🌱 Create a Feature Branch

```bash
git checkout -b feature/my-changes
```

### 📝 Edit and Test

* Modify scripts, admin tools, or challenge folders.  
* Test your changes in:  
  - **Folder mode** (launch scripts directly).  
  - **Web portal mode** (rebuild student portal and test).  

### 🔄 Build the Student Bundle

To generate the student-facing version (removes admin tools):  

```bash
cd CCRI_CTF/web_version_admin/create_website
./build_web_version.sh
```

This creates an obfuscated, student-ready web portal in `CCRI_CTF/web_version/`.  

### 💾 Commit and Push

```bash
git add .
git commit -m "Add new challenge or fix admin tool"
git push origin feature/my-changes
```

### 🔀 Open a Pull Request (PR)

1. Go to the repo on GitHub.  
2. Click **“Compare & pull request.”**  
3. Describe your changes.  
4. Submit for review and merging.  

---

## 🛡️ Rules for Contributors

✅ Keep admin-only flags and tools **out of `web_version/`**  
✅ Test all scripts from both folder mode and web portal mode  
✅ Use relative paths (avoid absolute paths) for portability  
✅ Don’t commit generated `.pyc` files or student-only builds  

---

## 📣 About the Public Bundle

Students will receive a **separate public folder** containing only the web portal, challenges, and the desktop launcher.  
This repo stays **private** for club development and admin workflows.  

---

## 🙌 Thanks for contributing to CCRI CyberKnights STEM Day CTF!
