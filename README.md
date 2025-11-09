# Windows Setup Scripts

A collection of scripts and configuration files for automating Windows PC setup using Winget, PowerShell modules, Python packages, and VS Code extensions.

## Quick Start - 5-Step Setup Process

**Before you begin:** Review `0-windows-prerequisites.md` to ensure all required Windows features and BIOS settings are configured.

For a complete development environment, run these files in order:

1. **System Configuration & WSL Setup**
   ```powershell
   # Run as Administrator
   .\1-windows-system-config.ps1
   # RESTART YOUR COMPUTER after this step
   ```

2. **(Optional) WSL CLI Tools Setup**
   - After restart, follow manual steps in `1b-wsl-cli-setup.md`
   - Node.js (NVM), Codex CLI, Claude Code CLI
   - All steps are optional

3. **Install Applications via Winget**
   ```powershell
   # Run as Administrator (recommended)
   # Copy and paste commands from 2-winget-development.txt
   # REQUIRED: Install at minimum VS Code, PowerShell, and Python for next steps
   # OPTIONAL: All other applications based on your needs
   ```

4. **Install VS Code Extensions**
   ```powershell
   # Run as regular user
   # Copy and paste commands from 3-vscode-extensions.txt
   ```

5. **Install PowerShell Modules**
   ```powershell
   # Run as regular user (NOT admin)
   .\4-powershell-modules-setup.ps1
   ```

6. **Install Python Packages**
   ```bash
   pip install -r 5-python-requirements.txt
   ```

## Files

### 0-windows-prerequisites.md
**STEP 0 (REVIEW FIRST)** - Prerequisites and required Windows features:
- Windows features (WSL, Virtual Machine Platform)
- BIOS settings (Virtualization)
- Service requirements (Docker, VS Code extensions)
- Winget installation verification
- Quick check commands
- Troubleshooting guide

**Important items:**
- Virtualization must be enabled in BIOS (required for WSL 2 and Docker)
- Winget must be installed (pre-installed on Windows 11)
- Windows 10 version 2004 or higher required
- At least 60GB free disk space recommended

### 1-windows-system-config.ps1
**STEP 1 OF 5** - Windows system configuration script:
- Power settings (disable sleep)
- WSL2 (Windows Subsystem for Linux) installation
- **Requires system restart after completion**

**Usage:**
```powershell
# Run as Administrator
.\1-windows-system-config.ps1
```

### 1b-wsl-cli-setup.md
**STEP 1b (OPTIONAL)** - Manual WSL CLI tools setup guide:
- Node.js installation via NVM
- OpenAI Codex CLI setup
- Claude Code CLI setup
- Must be done AFTER step 1 and system restart
- All steps are optional and manual

**Prerequisites:**
- WSL must be installed (from step 1)
- System must be restarted

**Covers:**
- NVM (Node Version Manager) installation in WSL
- Node.js installation
- Codex CLI (OpenAI) - optional
- Claude Code CLI (Anthropic) - optional
- Usage tips and workflow suggestions

### 2-winget-development.txt
**STEP 2 OF 5** - Complete Windows application setup organized into two sections:

**REQUIRED DEPENDENCIES** (for steps 3-5):
- VS Code (required for step 3)
- PowerShell (required for step 4)
- Python 3.12 + Python Launcher (required for step 5)

**OPTIONAL STANDALONE APPLICATIONS**:
- Browsers & Communication (Chrome, Discord)
- Microsoft Essentials (Office, OneDrive)
- Core Development Tools (Git, GitHub Desktop, Notepad++)
- Programming Languages & Runtimes (Node.js, .NET SDKs)
- AI & Machine Learning (Claude, Ollama)
- Database & SQL Tools (SSMS, ODBC drivers)
- Containers & Virtualization (Docker Desktop)
- Advanced Development (Visual Studio 2022, VSTOR, WebDeploy)
- Essential Utilities (7-Zip, VLC, Everything, ShareX, Adobe Reader, CPU-Z)
- Security & Network Tools (KeePass, Wireshark, Malwarebytes, ProtonVPN)
- Cloud & Backup (Dropbox)
- Remote Access (AnyDesk)
- Media & Entertainment (OBS, Spotify, Steam)
- Runtimes & Dependencies (.NET Desktop Runtimes, VC Redist, UI.Xaml)
- System Utilities (PowerToys, Windows Terminal, Sysinternals)

**Usage:**
```powershell
# Copy and paste commands directly into PowerShell (admin recommended)
# At minimum, install the 4 REQUIRED items for steps 3-5 to work
```

### 3-vscode-extensions.txt
**STEP 3 OF 5** - VS Code extensions organized by category (50+ extensions):
- AI & Copilot (Claude Code, GitHub Copilot, ChatGPT)
- Python Development
- C# / .NET Development
- Java Development
- SQL / Database
- C/C++ Development
- Remote Development
- Containers & Kubernetes
- AutoHotkey
- Other Utilities (GitLens, ESLint, Rainbow CSV, YAML, PowerShell)

**Prerequisites:**
- VS Code must be installed (from step 2)
- The `code` command must be in PATH (restart terminal if needed)

**Usage:**
```powershell
# Run as regular user
# Copy and paste commands directly or run entire file
```

### 4-powershell-modules-setup.ps1
**STEP 4 OF 5** - Installs essential PowerShell modules for automation and development:
- ImportExcel - Excel file manipulation without Excel
- dbatools - SQL Server automation
- PSWindowsUpdate - Windows Update management
- BurntToast - Toast notifications
- PSWriteHTML - HTML reports and dashboards
- Pester - Testing framework
- posh-git - Git integration for PowerShell prompt
- SqlServer - SQL Server cmdlets

**Prerequisites:**
- PowerShell must be installed (from step 2)

**Usage:**
```powershell
# Run as regular user (NOT admin)
.\4-powershell-modules-setup.ps1
```

### 5-python-requirements.txt
**STEP 5 OF 5** - Python package requirements organized by category:
- Web automation & scraping (Selenium, BeautifulSoup, webdriver-manager)
- Data processing (Pandas, openpyxl)
- Utilities (requests, cryptography, schedule)
- Optional ML packages (transformers, accelerate, torch)

**Prerequisites:**
- Python must be installed (from step 2)

**Usage:**
```bash
pip install -r 5-python-requirements.txt
```

## Maintenance

Update all installed winget packages:
```powershell
winget upgrade --all
```

Update PowerShell modules:
```powershell
Update-Module -Force
```

Update Python packages:
```bash
pip install --upgrade -r 5-python-requirements.txt
```

## Notes

- All files are numbered (1-5) to indicate execution order
- Step 2 separates REQUIRED dependencies from OPTIONAL applications
- All winget commands use consistent `-e --id` format for exact matching
- PowerShell modules are installed with `-Scope CurrentUser` (no admin needed)
- Scripts are designed to be idempotent (safe to run multiple times)
- Files are organized by purpose for easy navigation and customization

## License

Feel free to use and modify these scripts for your own setup needs.
