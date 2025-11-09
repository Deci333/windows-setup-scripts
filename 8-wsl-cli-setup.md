# WSL CLI Setup Guide
**STEP 8:** Manual setup for WSL command-line tools
**Last updated:** 2025-11-09

This step covers CLI tool installations for WSL (Windows Subsystem for Linux).

## Prerequisites

✅ **Before starting:**
1. WSL must be installed (via step 1: `1-windows-system-config.ps1`)
3. Ubuntu (or your chosen Linux distribution) must be set up
4. Git should already be installed on Windows (from step 2)

## Starting WSL

Open PowerShell or Windows Terminal and enter WSL:
# Terminology - bash is a shell like powershell|pwsh, but for mac/linux. 
# In this guide - We enter open bash by running "wsl" in powershell
```Powershell
wsl
```

You should now be in your Linux shell (Ubuntu by default).

## Baseline Package Setup

Before installing development tools, update your system and install essential build tools.

### Update System Packages

```bash
# Update package lists
sudo apt update

# Upgrade existing packages
sudo apt upgrade -y
```

### Install Essential Development Tools

```bash
# Install core build tools and utilities
sudo apt install -y \
    build-essential \
    git \
    curl \
    wget \
    unzip \
    python3 \
    python3-pip \
    pkg-config \
    ca-certificates
```

**What these packages provide:**
- **build-essential**: C/C++ compilers and build tools (required for Node.js native modules)
- **git**: Version control (WSL version, separate from Windows Git)
- **curl/wget**: Download tools
- **unzip**: Archive extraction
- **python3/python3-pip**: Python runtime and package manager
- **pkg-config**: Build configuration tool
- **ca-certificates**: SSL/TLS certificates for secure connections

### Verify Installation

```bash
# Check installed tools
git --version
python3 --version
gcc --version
```

## Node.js Setup via NVM

### 1. Install NVM (Node Version Manager)

Run this command in WSL:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
```

### 2. Restart your WSL terminal

Close and reopen WSL, or run:
```bash
source ~/.bashrc
```

### 3. Install Node.js

```bash
# Install Node.js version 22
nvm install 22

# Set Node 22 as the default version for all new shells
nvm alias default 22

# Use Node 22 in current shell
nvm use 22
```

### 4. Verify Installation

```bash
node --version
npm --version
nvm current  # Should show v22.x.x
```

### 5. Configure npm Global Packages (Avoid sudo)

To install npm global packages without sudo, configure npm to use a user directory:

```bash
# Create directory for global npm packages
mkdir -p ~/.npm-global

# Configure npm to use this directory
npm config set prefix ~/.npm-global

# Add to PATH - append to ~/.bashrc
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc

# Reload bashrc
source ~/.bashrc
```

**Verify:**
```bash
# This should show your user directory
npm config get prefix
# Expected: /home/yourusername/.npm-global
```

Now you can install global npm packages without sudo:
```bash
# Example: Install packages without sudo
npm install -g typescript
npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex
```

## Codex CLI Setup

OpenAI Codex CLI for terminal-based AI assistance.

### Install Codex

```bash
npm i -g @openai/codex
```

### First Run

```bash
codex
```

**Note:** You will be prompted to login with your OpenAI account on first run. Click the link to authenticate.

### Usage

Run codex in VS Code WSL terminal:
```bash
wsl
codex
```

You can use command line commands or natural language to interact with Codex.

### Update Codex

```bash
npm i -g @openai/codex@latest
```

## Claude Code CLI Setup

Anthropic's Claude Code CLI for terminal-based AI coding assistance.

### Installation Options

**Option 1: NPM (Recommended for WSL)**
```bash
npm install -g @anthropic-ai/claude-code
```
**Option 2: NPM with sudo (if permission issues)**
```bash
sudo npm install -g @anthropic-ai/claude-code
```
**Option 3: Direct install script**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```
**Option 4: For Windows PowerShell (direct)**
```powershell
irm https://claude.ai/install.ps1 | iex
```

### Usage
Run Claude Code in VS Code terminal (PowerShell or WSL):
```bash
claude
```

### Verify Installation
```bash
claude --version
```

### Update Claude Code
In WSL:
```bash
npm install -g @anthropic-ai/claude-code
```

## Git Configuration in WSL

Git for Windows was installed in step 2, but WSL has its own separate Git installation (installed in the baseline packages above). You can use either or both depending on your workflow.

### Configure Git Identity

Set your Git identity for WSL (required for commits):

```bash
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set line ending behavior for WSL (Linux)
git config --global core.autocrlf input

# Set default branch name to 'main'
git config --global init.defaultBranch main

# Verify configuration
git config --global --list
```

**Line Ending Configuration:**
- **Windows Git**: `core.autocrlf true` (converts LF to CRLF on checkout)
- **WSL Git**: `core.autocrlf input` (converts CRLF to LF on commit, keeps LF on checkout)

### SSH Key Setup for WSL

Generate SSH keys for GitHub/GitLab access:

```bash
# Generate SSH key (use your email)
ssh-keygen -t ed25519 -C "your.email@example.com"

# Press Enter to accept default location (~/.ssh/id_ed25519)
# Press Enter for no passphrase (or enter a passphrase for extra security)
```

### Add SSH Key to ssh-agent

```bash
# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add your SSH private key
ssh-add ~/.ssh/id_ed25519

# Display your public key (add this to GitHub/GitLab)
cat ~/.ssh/id_ed25519.pub
```

### Add SSH Key to GitHub/GitLab

1. **Copy your public key:**
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. **Add to GitHub:**
   - Go to https://github.com/settings/keys
   - Click "New SSH key"
   - Paste your public key
   - Click "Add SSH key"

3. **Add to GitLab:**
   - Go to https://gitlab.com/-/profile/keys
   - Paste your public key
   - Click "Add key"

### Test SSH Connection

```bash
# Test GitHub connection
ssh -T git@github.com
# Expected: "Hi username! You've successfully authenticated..."

# Test GitLab connection
ssh -T git@gitlab.com
# Expected: "Welcome to GitLab, @username!"
```

### Sharing SSH Keys Between Windows and WSL

If you want to use the same SSH keys for both Windows and WSL:

```bash
# Create symbolic link to Windows SSH keys
ln -s /mnt/c/Users/YourWindowsUsername/.ssh ~/.ssh

# Fix permissions (important for SSH to accept the keys)
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

**Note:** Replace `YourWindowsUsername` with your actual Windows username.

### Windows Git vs WSL Git

**When to use Windows Git:**
- Working with Windows file system (`C:\`, `D:\`, etc.)
- Using Git in PowerShell or Windows Terminal
- GUI tools like GitHub Desktop

**When to use WSL Git:**
- Working with WSL file system (`/home/username/`)
- Using Git in WSL terminal
- Development inside WSL environment
- Better performance for WSL-based projects

**Best Practice:**
- Use Windows Git for Windows-based projects
- Use WSL Git for WSL-based projects
- Keep configurations separate (different line ending settings)
- Share SSH keys if you want unified authentication

## CLI Tools Workflow Tips
**Codex vs Claude Code:**
- Use Claude Code for making actual code changes (saves Codex usage limits)
- Use Codex to assist when errors persist or for code review
- Good to have both as fallback options if you hit rate limits

**Example Workflow:**
1. Ask Codex to review files in a folder
2. Post Codex results back to Claude Code for implementation
3. Use Claude Code to make the actual changes
4. This approach conserves usage limits on both tools
5. OR - Ask them both the same question, Post codex results to ClaudeCode to help create a better plan

## Troubleshooting
**WSL command not found:**
- Make sure you've restarted your computer after running `1-windows-system-config.ps1`
- Verify WSL is installed: `wsl --status` in PowerShell

**NVM command not found:**
- Restart your WSL terminal
- Run: `source ~/.bashrc`

**Permission errors with npm:**
- Follow the npm global configuration steps above (section 5 under Node.js Setup)
- Never use `sudo` with npm - it's a security risk
- Properly configured npm should not require sudo