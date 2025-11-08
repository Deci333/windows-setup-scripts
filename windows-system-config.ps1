# Windows System Configuration Script
# Run in PowerShell as Administrator
# Last updated: 2025-11-07

# === POWER SETTINGS ===
# Prevent sleep when plugged in
powercfg /change standby-timeout-ac 0

# Prevent sleep when on battery
powercfg /change standby-timeout-dc 0

Write-Host "Power settings configured - sleep disabled" -ForegroundColor Green

# === WSL SETUP ===
# Install Windows Subsystem for Linux with default Ubuntu distribution
# wsl --install

# After WSL is installed, run these commands inside WSL:
<#
# Start WSL shell
wsl

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Restart WSL or open new terminal, then install Node.js
nvm install 22

# Install Codex (if needed)
npm i -g @openai/codex
codex
#>

Write-Host "System configuration complete!" -ForegroundColor Green
Write-Host "To set up WSL, uncomment and run the WSL section" -ForegroundColor Yellow
