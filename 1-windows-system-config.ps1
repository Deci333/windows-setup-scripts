# Windows System Configuration Script
# STEP 1 OF 7: Run this file FIRST
# Run in PowerShell as Administrator
# IMPORTANT: System restart required after WSL installation
# Last updated: 2025-11-08
#

# === POWER SETTINGS ===
# Prevent sleep when plugged in
powercfg /change standby-timeout-ac 0

# Prevent sleep when on battery
powercfg /change standby-timeout-dc 0

Write-Host "Power settings configured - sleep disabled" -ForegroundColor Green

# === WSL SETUP ===
# Install Windows Subsystem for Linux with default Ubuntu distribution
Write-Host "`nInstalling WSL..." -ForegroundColor Cyan
wsl --install

Write-Host "`n===========================================================" -ForegroundColor Green
Write-Host "System configuration complete!" -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Green
Write-Host "`nIMPORTANT: RESTART YOUR COMPUTER before proceeding.`n" -ForegroundColor Yellow

Write-Host "After restart:" -ForegroundColor Cyan
Write-Host "  1. (Optional) See 1b-wsl-cli-setup.md for WSL CLI tools setup" -ForegroundColor White
Write-Host "     (Node.js, Codex, Claude Code)" -ForegroundColor White
Write-Host "  2. Continue with: 2-winget-development.ps1" -ForegroundColor White
Write-Host "`n===========================================================" -ForegroundColor Green
