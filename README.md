# Windows Setup Scripts

A collection of scripts and configuration files for automating Windows PC setup using Winget, PowerShell modules, Python packages, and VS Code extensions.
- May prove useful in setting up and standardizing multiuple PC's
- Highly customizable, assets can easily be changed in the .psd1 files
- Current setup is designed to engage the user, once refined - We will add a toggle for user Y/N Prompts.
A semi-automated or at least guided method to for beginners: 
- reduce setup friction so that the user can get up and running in an IDE with CLI Agents.
- gain some familiarity with fundamentals
All .ps1's designed so they can be run and re-run
- This provides a check to confirm that proper changes have been made.  
- This should serve to provide useful information and simplify troubleshooting where necessary.
Sections not yet finalized or to be added
- Docker setup and confirmed operational
- Ubuntu setup and confirmed operational
- Custom scheduled task creator

## Quick Start

**Before you begin:** Review `0-windows-prerequisites.md` to ensure all required Windows features, BIOS settings, and Git configuration are understood.

For a complete development environment, run these files in order:

1. **System Configuration & WSL Setup**
   ```powershell
   # Run as Administrator
   cd "Your-local-Repo-Dir Here"
   .\1-windows-system-config.ps1
   # RESTART YOUR COMPUTER after this step
   ```

2. **Install Applications via Winget**
   ```powershell
   # Run as Administrator (recommended)
   .\2-winget-development.ps1
   # Uses config/winget-packages.psd1
   # REQUIRED: VS Code, PowerShell, Python, and Git (automatically installed)
   ```

 **2a Configure Git**
   ```powershell
   # Run as regular user (NOT admin)
   .\2a-git-setup.ps1
   # Interactive script to configure Git identity and SSH keys
   # Sets user.name, user.email, line endings, default branch
   # Optionally generates SSH keys for GitHub/GitLab
   ```

3. **Install VS Code Extensions**
   ```powershell
   # Run as regular user
   .\3-vscode-extensions.ps1
   # Uses config/vscode-extensions.psd1
   ```

4. **Install PowerShell Modules**
   ```powershell
   # Run as Administrator
   .\4-powershell-modules-setup.ps1
   # Uses config/powershell-modules.psd1
   ```

5. **Install Python Packages**
   ```powershell
   # Run as regular user (NOT admin)
   .\5-python-packages-setup.ps1
   # Uses config/python-packages.psd1
   ```

6. **Configure Windows Services**
   ```powershell
   # Run as Administrator
   .\6-win-services.ps1
   # Uses config/win-services.psd1
   # Configure which Windows services should be running/disabled
   ```

7. **Configure Windows Features**
   ```powershell
   # Run as Administrator
   .\7-win-features.ps1
   # Uses config/win-features.psd1
   # Enable/disable optional Windows features
   ```

8. **WSL CLI Tools & Git Setup**
   - After completing (steps 1-2a), configure WSL environment
   - Follow manual steps in `8-wsl-cli-setup.md`
   - Includes: Baseline packages, NVM, Node.js, Git configuration, SSH keys
   - Includes: Codex CLI, Claude Code CLI, npm global setup

## Configuration & Customization

All package lists, extensions, modules, and settings are centralized in **PowerShell Data Files (.psd1)** located in the `config/` directory. This design provides a single source of truth - you can add, remove, or modify items without touching the script logic.

### Configuration Files

- **`config/winget-packages.psd1`** - Windows applications
  - Required dependencies: VS Code, PowerShell, Python
  - Optional applications organized by category (browsers, dev tools, utilities, etc.)

- **`config/vscode-extensions.psd1`** - VS Code extensions
  - Organized by category: AI, Python, C#, Java, SQL, Remote Development, etc.

- **`config/powershell-modules.psd1`** - PowerShell modules
  - Core modules
  - Optional modules

- **`config/python-packages.psd1`** - Python packages
  - Web automation
  - Data processing
  - ML packages

- **`config/win-services.psd1`** - Windows services baseline
  - Services to enable
  - Services to set as Manual
  - Services to disable

- **`config/win-features.psd1`** - Windows features baseline
  - Features to enable
  - Features to disable

### How to Customize

1. Open any `.psd1` file in your text editor (VS Code, Notepad++, etc.)
2. Add, remove, or modify entries in the hashtable arrays
3. Save the file
4. Run the corresponding script - it will automatically use your updated configuration

**Format:** PowerShell Data Files use hashtable syntax:
```powershell
@{Name="PackageName"; Version="1.0.0"; Desc="Description"}
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
**STEP 1** - Windows system configuration script:
- Power settings (disable sleep)
- PowerShell execution policy (RemoteSigned for CurrentUser)
- WSL2 (Windows Subsystem for Linux) installation
- **Requires system restart after completion**

**Usage:**
```powershell
# Run as Administrator
.\1-windows-system-config.ps1
```

### 2-winget-development.ps1
**STEP 2** - Complete Windows application setup organized into two sections:

**Configuration:** Uses `config/winget-packages.psd1`

**REQUIRED DEPENDENCIES** (for steps 3-9):
- VS Code (required for step 4)
- PowerShell (required for step 5)
- Python 3.12 + Python Launcher (required for step 6)
- Git (required for version control - automatically installed)
**OPTIONAL STANDALONE APPLICATIONS**

**Usage:**
```powershell
# Run as Administrator (recommended)
.\2-winget-development.ps1
# At minimum, install the REQUIRED items for steps 3-9 to work
```

### 2a-git-setup.ps1
**STEP 2a** - Interactive Git configuration script:

Configures Git for Windows with proper settings for development:
- Git identity (user.name and user.email)
- Line ending behavior (core.autocrlf true for Windows)
- Default branch name (main)
- Credential helper (Windows Credential Manager)
- SSH key generation for GitHub/GitLab (optional)
- Displays public SSH key for easy copying

**Prerequisites:**
- Git must be installed (from step 2)

**Usage:**
```powershell
# Run as regular user (NOT admin)
.\2a-git-setup.ps1

# Follow interactive prompts to configure Git
```

**Note:** You can also configure Git manually or skip if you've already configured it.

### 3-vscode-extensions.ps1
**STEP 3** - VS Code extensions organized by category (50+ extensions):

**Configuration:** Uses `config/vscode-extensions.psd1`

**Prerequisites:**
- VS Code must be installed (from step 2)
- The `code` command must be in PATH (restart terminal if needed)

**Usage:**
```powershell
# Run as Administrator (recommended)
.\3-vscode-extensions.ps1
```

### 4-powershell-modules-setup.ps1
**STEP 4** - Installs essential PowerShell modules for automation and development:

**Configuration:** Uses `config/powershell-modules.psd1`

**Prerequisites:**
- PowerShell must be installed (from step 2)

**Usage:**
```powershell
# Run as Administrator
.\4-powershell-modules-setup.ps1
```

### 5-python-packages-setup.ps1
**STEP 5** - Python package requirements organized by category:

**Configuration:** Uses `config/python-packages.psd1`

**Prerequisites:**
- Python must be installed (from step 2)

**Usage:**
```powershell
# Run as Administrator (recommended)
.\5-python-packages-setup.ps1
```

### 6-win-services.ps1
**STEP 6** - Windows Services configuration:

**Configuration:** Uses `config/win-services.psd1`

Interactively configure Windows services:
- Disable unnecessary services to improve performance
- Enable required services for specific applications
- Check current service state before making changes
- Includes audit script: `6-audit-win-services.ps1` (view-only mode)

**Prerequisites:**
- Must be run as Administrator

**Usage:**
```powershell
# Run as Administrator
.\6-win-services.ps1
```

**Audit mode (no changes):**
```powershell
# Safe to run without admin (view-only)
.\6-audit-win-services.ps1
```

### 7-win-features.ps1
**STEP 7** - Windows Features configuration:

**Configuration:** Uses `config/win-features.psd1`
- Includes audit script: `7-audit-win-features.ps1` (view-only mode)

**Prerequisites:**
- Must be run as Administrator
- May require system restart after changes

**Usage:**
```powershell
# Run as Administrator
.\7-win-features.ps1
```

**Audit mode (no changes):**
```powershell
# Requires Administrator (view-only)
.\7-audit-win-features.ps1
```

### 8-wsl-cli-setup.md
**STEP 8** - WSL CLI Tools Setup Guide:

Manual setup guide for WSL command-line development tools:
- Baseline package setup (apt update/upgrade + build tools)
- NVM (Node Version Manager) installation
- Node.js installation and default version configuration
- OpenAI Codex CLI setup
- Anthropic Claude Code CLI setup
- Git configuration in WSL (identity, SSH keys, line endings)
- npm global packages configuration (no sudo required)
- Windows Git vs WSL Git guidance
- Usage tips and workflow suggestions

**Prerequisites:**
- Complete steps up to 2a
- WSL must be installed and restarted
- Ubuntu (or chosen Linux distribution) configured

**Covers:**
- Baseline package setup (build-essential, git, curl, python3, etc.)
- NVM installation and Node.js setup
- Setting Node.js as default version
- Installing CLI tools (Codex, Claude Code)
- Git identity and SSH key configuration
- Proper npm global package configuration (avoiding sudo)
- systemd and .wslconfig configuration

**Note:** Everything is this step is manual. Follow the guide inside WSL terminal.

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
```powershell
.\5-python-packages-setup.ps1
```

## Notes

- All files are sequential, if a letter follows initial number, do the numbered step first. ex - do 2 before 2a
- Steps 6-8 (services, features, and WSL CLI configuration)
- Step 2+2a now includes Git as a REQUIRED dependency
- Scripts for steps 2-7 use centralized configuration files in config/*.psd1
- Scripts are designed to be idempotent (safe to run multiple times)
- Scripts are also designed as a way to check for change. run once, reboot, run again to confirm everything is as intended
- Files are organized by purpose for easy navigation and customization

## License

Feel free to use and modify these scripts for your own setup needs.
