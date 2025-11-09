# USE THIS FOR TROUBLESHOOTING ONLY
# Windows Prerequisites & Required Services
**Last updated:** 2025-11-08

This document lists all Windows features, services, and BIOS settings required for the applications in this setup.

## Quick Check Commands

```powershell
# Check if virtualization is enabled (MOST IMPORTANT)
systeminfo | findstr /i "Virtualization"
# Look for: "Status: Running", "Base Virtualization Support", or "Enabled In Firmware: Yes"
# Any virtualization-related output with "Running" or "Enabled" means it's working!

# Check if WSL is installed
wsl --status
# Desired results something like this
# Default Distribution: Ubuntu  Default Version: 2

# Check Windows optional features (requires Admin)
Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like "*WSL*" -or $_.FeatureName -like "*VirtualMachine*"}
# FeatureName : VirtualMachinePlatform
# State       : Enabled

# Check if Hyper-V is running
Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object HypervisorPresent
# HypervisorPresent   TRUE
# True means a hypervisor (WSL 2 or Hyper-V) is currently running

# Check winget
winget --version
# Minimum required: v1.0+ (you exceed this)
# Latest stable as of late 2024: v1.12.x series

# Check Windows version
Get-ComputerInfo | Select-Object WindowsVersion, OsBuildNumber
# Windows 10 (2004): Build 19041 (minimum required)
# Windows 11 21H2: Build 22000
# Windows 11 22H2: Build 22621
# Windows 11 23H2: Build 22631
# Windows 11 24H2: Build 26100 
```

## Required Windows Features
### 1. Windows Subsystem for Linux (WSL) 

**Required for:**
- Step 1: WSL installation (1-windows-system-config.ps1)
- Step 1b: WSL CLI tools (Node.js, Codex, Claude Code)
- Step 2: Docker Desktop (uses WSL 2 backend)
- Step 3: VS Code Remote Development extensions

**Features needed:**
- `Microsoft-Windows-Subsystem-Linux`
- `VirtualMachinePlatform`

**Auto-installed by:** `wsl --install` command in step 1

**Manual installation (if needed):**
```powershell
# Run as Administrator
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**Verify:**
```powershell
wsl --status
wsl --list --verbose
# Desired results something like this
# Default Distribution: Ubuntu  Default Version: 2
```

### 2. Virtualization Technology (BIOS/UEFI Setting)

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
1. Open Task Manager (Ctrl + Shift + Esc)
2. Click **Performance** tab
3. Click **CPU** in left sidebar
4. Look for **"Virtualization: Enabled"** on the right side

**Verify - Method 2 (Command Line Check):**
```powershell
# Run in PowerShell (any privilege level)
systeminfo | findstr /i "Virtualization"
```

**Verify - Method 3 (WMI/CIM Check):**
```powershell
# Run in PowerShell
Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object HypervisorPresent
# Look for: "HypervisorPresent : True"
# True means a hypervisor (WSL 2 or Hyper-V) is currently running
```

**If virtualization shows as Disabled:**
- You MUST enable it in BIOS/UEFI (see steps above)
- This is REQUIRED for WSL 2 and Docker Desktop to work
- Your system will not be able to complete the setup without this enabled

### 3. Hyper-V (Optional - Alternative to WSL 2 for Docker)

**Required for:**
- Docker Desktop (if not using WSL 2 backend)
- Visual Studio Android emulator
- Windows Sandbox

**Note:** Most users should use WSL 2 backend for Docker instead of Hyper-V.

**Enable Hyper-V (if needed):**
```powershell
# Run as Administrator
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

**Available only on:**
- Windows 10/11 Pro, Enterprise, or Education
- NOT available on Windows Home (use WSL 2 instead)

## Winget Requirement

**Required for:**
- Step 2: All application installations (2-winget-development.txt)

**Pre-installed on:**
- Windows 11 (built-in)
- Windows 10 with "App Installer" from Microsoft Store

**Install if missing:**
1. Open Microsoft Store
2. Search for "App Installer"
3. Install/Update

**Verify:**
```powershell
winget --version
```

## Application-Specific Requirements

### Docker Desktop

**Prerequisites:**
- WSL 2 installed (from step 1)
- WSL 2 kernel updated
- Virtualization enabled in BIOS
- At least 4GB RAM recommended
- 20GB free disk space

**Verify WSL 2:**
```powershell
wsl --set-default-version 2
wsl --list --verbose
# VERSION column should show "2"
```

### Visual Studio 2022 Community

**Prerequisites:**
- 10-50 GB free disk space (varies by workloads)
- IIS (optional - only for web development workloads)

### VS Code Remote Development Extensions
**Prerequisites:**
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

# Log and monitor with
Get-WinEvent -LogName "Microsoft-Windows-OpenSSH/Operational"
```

## PowerShell 7 (PowerShell Core)
**Note:** PowerShell 7 is installed in step 2 (2-winget-development.txt)
**No special Windows features required** - it runs alongside Windows PowerShell 5.1

## Python & pip
**No special Windows features required**
Python is installed via winget in step 2.

## Troubleshooting
### WSL installation fails
- Ensure virtualization is enabled in BIOS
- Check Windows version: `winver` (need 2004 or later)
- Run Windows Update to get latest patches

### Docker Desktop won't start
- Verify WSL 2 is installed: `wsl --status`
- Check virtualization: must be enabled in BIOS
- Restart computer after enabling virtualization

### Winget not found
- Install "App Installer" from Microsoft Store
- On Windows 10, ensure you have latest updates

#### Proceed to: **1-windows-system-config.ps1** (Step 1)
