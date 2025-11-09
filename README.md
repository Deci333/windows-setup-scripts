# Windows Setup Scripts

A collection of scripts and configuration files for automating Windows PC setup using Winget, PowerShell modules, Python packages, and VS Code extensions.

## Quick Start - 7-Step Setup Process

Review `0-windows-prerequisites.md` to ensure all required Windows features and BIOS settings are configured. Backtrack to here later for troubleshooting if needed.

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

3. **Install Applications via Winget**
   ```powershell
   # Run as Administrator (recommended)
   .\2-winget-development.ps1
   # Uses config/winget-packages.psd1
   # REQUIRED: Install at minimum VS Code, PowerShell, and Python for next steps
   # OPTIONAL: All other applications based on your needs
   ```

4. **Install VS Code Extensions**
   ```powershell
   # Run as regular user
   .\3-vscode-extensions.ps1
   # Uses config/vscode-extensions.psd1
   ```

5. **Install PowerShell Modules**
   ```powershell
   # Run as Administrator
   .\4-powershell-modules-setup.ps1
   # Uses config/powershell-modules.psd1
   ```

6. **Install Python Packages**
   ```powershell
   # Run as regular user (NOT admin)
   .\5-python-packages-setup.ps1
   # Uses config/python-packages.psd1
   ```

7. **Configure Windows Services **
   ```powershell
   # Run as Administrator
   .\6-win-services.ps1
   # Uses config/win-services.psd1
   # Configure which Windows services should be running/disabled
   ```

8. **Configure Windows Features **
   ```powershell
   # Run as Administrator
   .\7-win-features.ps1
   # Uses config/win-features.psd1
   # Enable/disable optional Windows features
   ```

## Configuration & Customization

All package lists, extensions, modules, and settings are centralized in **PowerShell Data Files (.psd1)** located in the `config/` directory. This design provides a single source of truth - you can add, remove, or modify items without touching the script logic.

### Configuration Files

- **`config/winget-packages.psd1`** - Windows applications (66+ packages)
  - Required dependencies: VS Code, PowerShell, Python
  - Optional applications organized by category (browsers, dev tools, utilities, etc.)

- **`config/vscode-extensions.psd1`** - VS Code extensions (48+ extensions)
  - Organized by category: AI, Python, C#, Java, SQL, Remote Development, etc.

- **`config/powershell-modules.psd1`** - PowerShell modules (12 modules)
  - Core modules: ImportExcel, dbatools, PSWindowsUpdate, Pester, etc.
  - Optional modules: Azure (Az), AWS Tools

- **`config/python-packages.psd1`** - Python packages (12 packages)
  - Web automation: Selenium, BeautifulSoup, webdriver-manager
  - Data processing: Pandas, openpyxl
  - ML packages: PyTorch, Transformers, Accelerate

- **`config/win-services.psd1`** - Windows services baseline
  - Services to enable (Automatic/Running)
  - Services to set as Manual
  - Services to disable (security/performance)

- **`config/win-features.psd1`** - Windows features baseline
  - Features to enable (.NET Framework, Hyper-V, etc.)
  - Features to disable (legacy protocols, unused components)

### How to Customize

1. Open any `.psd1` file in your text editor (VS Code, Notepad++, etc.)
2. Add, remove, or modify entries in the hashtable arrays
3. Save the file
4. Run the corresponding script - it will automatically use your updated configuration

**Format:** PowerShell Data Files use hashtable syntax:
```powershell
@{Name="PackageName"; Version="1.0.0"; Desc="Description"}
```

**Benefits:**
- Single source of truth for all configurations
- No need to edit script logic when adding/removing items
- Easy to version control and share across machines
- Scripts remain clean and focused on installation logic

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
**STEP 1 OF 7** - Windows system configuration script:
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

### 2-winget-development.ps1
**STEP 2 OF 7** - Complete Windows application setup organized into two sections:

**Configuration:** Uses `config/winget-packages.psd1`

**REQUIRED DEPENDENCIES** (for steps 3-7):
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
# Run as Administrator (recommended)
.\2-winget-development.ps1
# At minimum, install the REQUIRED items for steps 3-7 to work
```

### 3-vscode-extensions.ps1
**STEP 3 OF 7** - VS Code extensions organized by category (50+ extensions):

**Configuration:** Uses `config/vscode-extensions.psd1`
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
# Run as Administrator (recommended)
.\3-vscode-extensions.ps1
```

### 4-powershell-modules-setup.ps1
**STEP 4 OF 7** - Installs essential PowerShell modules for automation and development:

**Configuration:** Uses `config/powershell-modules.psd1`
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
# Run as Administrator
.\4-powershell-modules-setup.ps1
```

### 5-python-packages-setup.ps1
**STEP 5 OF 7** - Python package requirements organized by category:

**Configuration:** Uses `config/python-packages.psd1`
- Web automation & scraping (Selenium, BeautifulSoup, webdriver-manager)
- Data processing (Pandas, openpyxl)
- Utilities (requests, cryptography, schedule)
- Optional ML packages (transformers, accelerate, torch)

**Prerequisites:**
- Python must be installed (from step 2)

**Usage:**
```powershell
# Run as Administrator (recommended)
.\5-python-packages-setup.ps1
```

### 6-win-services.ps1
**STEP 6 OF 7 (OPTIONAL)** - Windows Services configuration:

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
**STEP 7 OF 7 (OPTIONAL)** - Windows Features configuration:

**Configuration:** Uses `config/win-features.psd1`

Interactively enable/disable Windows optional features:
- .NET Framework versions
- Legacy components
- Media features
- Check current feature state before making changes
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

- All files are numbered (0-7) to indicate execution order
- Step 2 separates REQUIRED dependencies from OPTIONAL applications
- All scripts (steps 2-7) use centralized configuration files in config/*.psd1
- Scripts are designed to be idempotent (safe to run multiple times)
- Files are organized by purpose for easy navigation and customization

## License

Feel free to use and modify these scripts for your own setup needs.
