# Windows System Configuration

**STEP 1** | Run in PowerShell as Administrator | Restart required after completion

Last updated: 2025-12-05

---

## Prerequisites

1. Open **PowerShell as Administrator**
   - Right-click Start menu → "Terminal (Admin)" or "Windows PowerShell (Admin)"

---

## Power Settings

Prevent sleep when plugged in:

```powershell
powercfg /change standby-timeout-ac 0
```

Prevent sleep when on battery:

```powershell
powercfg /change standby-timeout-dc 0
```

---

## Execution Policy

Set execution policy to allow running PowerShell scripts. This must be run manually because a .ps1 script cannot enable its own execution.

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

Verify the change:

```powershell
Get-ExecutionPolicy -Scope CurrentUser
```

Expected output: `RemoteSigned`

---

## WSL Installation

Install Windows Subsystem for Linux with default Ubuntu distribution:

```powershell
wsl --install
```

This installs:
- WSL 2 (Windows Subsystem for Linux)
- Ubuntu (default distribution)

---

## Post-Configuration

**IMPORTANT: RESTART YOUR COMPUTER** before proceeding to Step 2.

After reboot:
- Continue with: `2-winget-development.ps1`
- WSL will complete Ubuntu setup on first launch (create username/password)

---

## Troubleshooting

### Execution Policy Still Blocked

If you get "running scripts is disabled" errors, verify admin rights and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
```

### WSL Installation Fails

Ensure virtualization is enabled in BIOS (see `0-windows-prerequisites.md`).

Check WSL status:

```powershell
wsl --status
```
