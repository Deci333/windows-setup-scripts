# WSL CLI Setup Guide
**STEP 1b (OPTIONAL):** Manual setup for WSL command-line tools
**Run after:** 1-windows-system-config.ps1 and system restart
**Last updated:** 2025-11-08

This guide covers optional CLI tool installations for WSL (Windows Subsystem for Linux).

## Prerequisites

✅ **Before starting:**
1. WSL must be installed (via `1-windows-system-config.ps1`)
2. **System must be restarted** after WSL installation
3. Ubuntu (or your chosen Linux distribution) must be set up

## Starting WSL

Open PowerShell or Windows Terminal and enter WSL:
```bash
wsl
```

You should now be in your Linux shell (Ubuntu by default).

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
nvm install 22
```

### 4. Verify Installation

```bash
node --version
npm --version
```

## Codex CLI Setup (Optional)

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

## Claude Code CLI Setup (Optional)

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
- Try using `sudo` for global installations
- Or configure npm to use a different directory for global packages