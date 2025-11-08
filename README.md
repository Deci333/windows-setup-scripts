# Windows Setup Scripts

A collection of scripts and configuration files for automating Windows PC setup using Winget, PowerShell modules, and Python packages.

## Files

### Winget Installation Scripts

#### `winget-essential.txt`
Complete Windows application setup with all essential software categorized by type:
- Browsers & Communication (Chrome, Discord)
- Microsoft Essentials (Office, OneDrive, PowerToys, Windows Terminal, etc.)
- Development Tools (VS Code, Git, Python, Node.js)
- Utilities (7-Zip, VLC, Everything, ShareX, Adobe Reader)
- Security & Network (Malwarebytes, KeePass, ProtonVPN, Wireshark)
- Cloud & Backup (Dropbox)
- Remote Access (AnyDesk)
- Media & Entertainment (OBS, Spotify, Steam)

**Usage:**
```powershell
# Copy and paste commands directly into PowerShell (admin recommended)
# Or run the entire file line by line
```

#### `winget-development.txt`
Developer-focused subset for setting up a programming environment:
- Core development tools (VS Code, Git, GitHub Desktop, Notepad++)
- Programming languages (Python 3.12, Node.js LTS)
- Database tools (SQL Server Management Studio)
- Containers (Docker Desktop)
- Advanced development (Visual Studio 2022 Community)
- Essential utilities and security tools

**Usage:**
```powershell
# Copy and paste commands directly into PowerShell (admin recommended)
```

### PowerShell Setup

#### `powershell-modules-setup.ps1`
Installs essential PowerShell modules for automation and development:
- ImportExcel - Excel file manipulation without Excel
- dbatools - SQL Server automation
- PSWindowsUpdate - Windows Update management
- BurntToast - Toast notifications
- PSWriteHTML - HTML reports and dashboards
- Pester - Testing framework
- posh-git - Git integration for PowerShell prompt
- SqlServer - SQL Server cmdlets

**Usage:**
```powershell
# Run as regular user (NOT admin)
.\powershell-modules-setup.ps1
```

### System Configuration

#### `windows-system-config.ps1`
Windows system configuration script:
- Power settings (disable sleep)
- WSL (Windows Subsystem for Linux) setup instructions
- Node.js setup in WSL via NVM

**Usage:**
```powershell
# Run as Administrator
.\windows-system-config.ps1
```

### Python Setup

#### `python-requirements.txt`
Python package requirements organized by category:
- Web automation & scraping (Selenium, BeautifulSoup)
- Data processing (Pandas, openpyxl)
- Utilities (requests, cryptography, schedule)
- Optional ML packages (transformers, torch)

**Usage:**
```bash
pip install -r python-requirements.txt
```

## Quick Start

### New PC Setup

1. **Install essential applications:**
   ```powershell
   # Open PowerShell as Administrator
   # Copy and paste commands from winget-essential.txt
   ```

2. **Set up PowerShell modules:**
   ```powershell
   # Run as regular user
   .\powershell-modules-setup.ps1
   ```

3. **Configure system settings:**
   ```powershell
   # Run as Administrator
   .\windows-system-config.ps1
   ```

4. **Install Python packages:**
   ```bash
   pip install -r python-requirements.txt
   ```

### Developer Setup

Use `winget-development.txt` instead of `winget-essential.txt` for a more focused development environment.

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
pip install --upgrade -r python-requirements.txt
```

## Notes

- All winget commands use consistent `-e --id` format for exact matching
- PowerShell modules are installed with `-Scope CurrentUser` (no admin needed)
- Scripts are designed to be idempotent (safe to run multiple times)
- Files are organized by purpose for easy navigation and customization

## License

Feel free to use and modify these scripts for your own setup needs.
