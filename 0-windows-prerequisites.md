# Windows Prerequisites & Required Services
# Step 0
**Last updated:** 2025-11-09

This document lists all Windows features, services, and BIOS settings required for the applications in this setup.

## Required Windows Features
**Check Windows version**
```powershell
Get-ComputerInfo | Select-Object WindowsVersion, OsBuildNumber
# Windows 10 (2004): Build 19041 (minimum required)
# Windows 11 21H2: Build 22000
# Windows 11 22H2: Build 22621
# Windows 11 23H2: Build 22631
# Windows 11 24H2: Build 26100 
```
**#################################################################**
### Enable|Check - Virtualization Technology (BIOS/UEFI Setting) 

**Required for:**
- WSL 2
- Docker Desktop
- Hyper-V (if used)
- Windows Subsystem for Android
- Virtual Machines
**How to enable:**
1. Restart computer
2. Enter BIOS/UEFI (usually F2, F10, F12, or Delete during boot)
3. Look for settings named:
   - Intel: "Intel VT-x" or "Intel Virtualization Technology"
   - AMD: "AMD-V" or "SVM Mode"
4. Enable the setting
5. Save and exit BIOS

**Verify - Method 1 (MOST RELIABLE - Task Manager Visual Check):**
1. Open Task Manager
2. Click **Performance** tab
3. Click **CPU** in left sidebar
4. Look for **"Virtualization: Enabled"** on the right side

**Method 1 should be all you need, but - Method 2 (Command Line Check):**
```powershell
# Check if virtualization is enabled (MOST IMPORTANT)
systeminfo | findstr /i "Virtualization"
# Look for: "Status: Running", "Base Virtualization Support", or "Enabled In Firmware: Yes"
# Any virtualization-related output with "Running" or "Enabled" means it's working!
```

**Method 1 should be all you need, but - Method 3 (WMI/CIM Check):**
```powershell
# Check if Hyper-V is running
Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object HypervisorPresent
# HypervisorPresent   TRUE
# True means a hypervisor (WSL 2 or Hyper-V) is currently running
```

**Method 1 should be all you need, but heres 1 more**
```powershell
# requires Admin
Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like "*WSL*" -or $_.FeatureName -like "*VirtualMachine*"}
# FeatureName : VirtualMachinePlatform
# State       : Enabled
```

### 3. Hyper-V (Optional - Alternative to WSL 2 for Docker - only avail on Windows 10/11 Pro, Enterprise, or Education)
**Note:** Most users should use WSL 2 backend for Docker instead of Hyper-V.
**Required for:** Docker Desktop (if not using WSL 2 backend) | Visual Studio Android emulator | Windows Sandbox
**Enable Hyper-V**
```powershell
# Run as Administrator
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

**#################################################################**
## Enable|Check - Winget

**Required for:** Step 2: All application installations (2-winget-development.ps1)
**Verify:**
```powershell
# Check winget
winget --version
# Minimum required: v1.0+ (you exceed this)
# Latest stable as of late 2024: v1.12.x series
```
**Pre-installed on:** Windows 11 (built-in)

**Install if missing:**
1. Open Microsoft Store
2. Search for "App Installer"
3. Install/Update

**#################################################################**
### Enable|Check - VS Code Remote Development Extensions - Optional
**Prerequisites:**
- Probably not necessary for most people
- SSH service (for Remote-SSH extension)
- WSL (for Remote-WSL extension) - already covered in step 1
- Docker (for Remote-Containers extension) - from step 2

**Enable OpenSSH Client (if needed):**
```powershell
# Run as Administrator

# Check if installed
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'
# Name  : OpenSSH.Client~~~~0.0.1.0
# State : Installed

# Install
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

**Enable OpenSSH Server (optional - only if you want to SSH INTO this machine):**
```powershell
# Run as Administrator
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# View OpenSSH event logs
Get-WinEvent -LogName "OpenSSH/Operational" -MaxEvents 10
```

# If issues here, try (MAKE SURE TO SWAP USERPROFILE TO MATCH YOURS) - enter code into link
```powershell
cd "C:\Users\USERPROFILE\AppData\Local\Programs\Microsoft VS Code\bin"
.\code-tunnel.exe tunnel user login
```

# After that completes, try creating the tunnel(REPLACE PCNAME WITH THE NAME OF YOUR PC):
```powershell
.\code-tunnel.exe tunnel --name PCNAME
.\code-tunnel.exe tunnel --name BFMAIN --log trace
```



**#################################################################**
### Troubleshoot - Windows Subsystem for Linux (WSL)

**Required for:**
- Step 1: WSL installation (1-windows-system-config.md)
- Step 1b: WSL CLI tools (Node.js, Codex, Claude Code) - optional
- Step 2: Docker Desktop (uses WSL 2 backend)
- Step 3: VS Code Remote Development extensions
**Features needed:**
- `Microsoft-Windows-Subsystem-Linux`
- `VirtualMachinePlatform`
**Auto-installed by:** `wsl --install` command in step 1. 

### WSL installation fails
- Ensure virtualization is enabled in BIOS
- Check Windows version: `winver` (need 2004 or later)
- Run Windows Update to get latest patches

**Check if features are installed:**
```powershell
# Quick check for both WSL features (no execution policy required)
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux, VirtualMachinePlatform | Select-Object FeatureName, State
# Expected output 
# Microsoft-Windows-Subsystem-Linux Enabled
# VirtualMachinePlatform            Enabled
```

**Manual installation (if needed):**
```powershell
# Run as Administrator
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**Verify WSL is working:**
```powershell
# Check if WSL is installed
wsl --status
wsl --list --verbose
# Desired results something like this
# Default Distribution: Ubuntu  Default Version: 2
```

**#################################################################**
## Troubleshoot - Git Requirement
**Required for:** Version control, development workflows, and collaboration
**Auto-installed in:** Step 2 (2-winget-development.ps1) as a required package

**Verify Git is installed:**
```powershell
# Check Git version
git --version
# Expected: git version 2.x.x or higher
```

**Check Git configuration:**
```powershell
# View current Git configuration
git config --global --list

# Check specific settings
git config --global user.name
git config --global user.email
```

**Initial Setup:**
After step 2 installs Git, you should configure it:
- **Step 2a (recommended):** Run `.\2a-git-setup.ps1` for interactive Git configuration
  - Sets user.name and user.email
  - Configures Windows line endings
  - Optionally generates SSH keys for GitHub/GitLab
- **Step 8 (for WSL):** See `8-wsl-cli-setup.md` for Git configuration in WSL environment

**Manual Configuration (if not using 2a-git-setup.ps1):**
```powershell
# Set your identity (required for commits)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set line ending behavior for Windows
git config --global core.autocrlf true

# Set default branch name to 'main'
git config --global init.defaultBranch main
```

**SSH Key Setup (for GitHub/GitLab):**
```powershell
# Generate SSH key (run in PowerShell or Git Bash)
ssh-keygen -t ed25519 -C "your.email@example.com"

# Display public key (add this to GitHub/GitLab)
cat ~/.ssh/id_ed25519.pub
```

**Add SSH key to GitHub:**
1. Copy the public key output from above
2. Go to GitHub.com → Settings → SSH and GPG keys
3. Click "New SSH key"
4. Paste your key and save

**#################################################################**
### Troubleshoot - Docker Desktop
**Prerequisites:**
- WSL 2 installed (from step 1)
- WSL 2 kernel updated
- Virtualization enabled in BIOS
- At least 4GB RAM recommended
- 20GB free disk space

### Docker Desktop won't start
- Verify WSL 2 is installed: `wsl --status`
- Check virtualization: must be enabled in BIOS
- Restart computer after enabling virtualization

**Verify WSL 2:**
```powershell
wsl --set-default-version 2
wsl --list --verbose
# VERSION column should show "2"
```

**#################################################################**
### Visual Studio 2022 Community - Optional
**Prerequisites:**
- Most will will just need VS Code, and will not use Visual Studio. Optional Download
- 10-50 GB free disk space (varies by workloads)
- IIS (optional - only for web development workloads)

## PowerShell 7 (PowerShell Core)
**Note:** PowerShell 7 is installed in step 2 (.\2-winget-development.ps1)
**No special Windows features required** - it runs alongside Windows PowerShell 5.1

## Python & pip
**No special Windows features required**
Python is installed via winget in step 2.

**#################################################################**
#### Proceed to: **1-windows-system-config.md** (Step 1)
