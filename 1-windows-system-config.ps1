# Windows System Configuration Script
# STEP 1
# Run in PowerShell as Administrator
# .\1-windows-system-config.ps1
# IMPORTANT: System restart required after WSL installation
# Last updated: 2025-11-08
#

# === POWER SETTINGS ===
# Prevent sleep when plugged in
powercfg /change standby-timeout-ac 0

# Prevent sleep when on battery
powercfg /change standby-timeout-dc 0

Write-Host "Power settings configured - sleep disabled" -ForegroundColor Green

# === EXECUTION POLICY ===
# Set execution policy to allow running PowerShell scripts
Write-Host "`nConfiguring PowerShell Execution Policy..." -ForegroundColor Cyan
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
    Write-Host "Execution Policy set to RemoteSigned for CurrentUser" -ForegroundColor Green
}
catch {
    Write-Host "Failed to set Execution Policy: $($_.Exception.Message)" -ForegroundColor Red
}

# === WSL SETUP ===
# Install Windows Subsystem for Linux with default Ubuntu distribution
Write-Host "`nInstalling WSL..." -ForegroundColor Cyan
wsl --install

Write-Host "`n===========================================================" -ForegroundColor Green
Write-Host "System configuration complete!" -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Green
Write-Host "`nIMPORTANT: RESTART YOUR COMPUTER before proceeding.`n" -ForegroundColor Yellow

Write-Host "After reboot:" -ForegroundColor Cyan
Write-Host "  - Continue with: 2-winget-development.ps1" -ForegroundColor White
Write-Host "`n===========================================================" -ForegroundColor Green
