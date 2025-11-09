# ==================================================================
# Winget Applications Interactive Installation
# Checks if applications are installed and prompts for installation
# STEP 2 OF 7: Run this file SECOND (after 1-windows-system-config.ps1)
# Run in elevated PowerShell (Run as Administrator recommended)
# Configuration: config/winget-packages.psd1
# .\2-winget-development.ps1
# Last updated: 2025-11-08
# ==================================================================

# Load centralized configuration
$configPath = Join-Path $PSScriptRoot "config\winget-packages.psd1"
if (-not (Test-Path $configPath)) {
    Write-Host "[X] ERROR: Configuration file not found: $configPath" -ForegroundColor Red
    Write-Host "Please ensure config\winget-packages.psd1 exists" -ForegroundColor Yellow
    exit 1
}
$config = Import-PowerShellDataFile -Path $configPath

# === PREREQUISITES ===
# 1. Winget must be installed
#    - Comes pre-installed with Windows 11
#    - For Windows 10: Install "App Installer" from Microsoft Store
#    - Verify with: winget --version
# 2. Run PowerShell as Administrator (recommended for best compatibility)
# 3. Docker Desktop requires WSL2 and virtualization enabled in BIOS
# 4. Visual Studio 2022 requires significant disk space (~10-50GB)

function Install-WingetPackageInteractive {
    param(
        [string]$Id,
        [string]$Description = "",
        [bool]$Required = $false,
        [bool]$Silent = $true
    )

    $desc = if ($Description) { " - $Description" } else { "" }
    $reqLabel = if ($Required) { "[REQUIRED]" } else { "[OPTIONAL]" }

    try {
        # Check if already installed using exact ID match
        # Suppress error output and capture result
        $listOutput = winget list --id $Id --exact 2>&1 | Out-String

        # Check if package is already installed
        # winget list returns the package if found, check output contains the ID
        $isInstalled = $listOutput -match [regex]::Escape($Id)

        if ($isInstalled) {
            Write-Host "[OK] $Id is already installed$desc" -ForegroundColor Green
            return
        }

        # Package not installed - prompt user
        Write-Host "`n$reqLabel $Id$desc" -ForegroundColor $(if ($Required) { "Yellow" } else { "Cyan" })
        Write-Host "  Status: Not installed" -ForegroundColor Cyan

        $response = Read-Host "  Install this package? (Y/n)"

        if ($response -eq '' -or $response -match '^[Yy]') {
            try {
                Write-Host "  Installing $Id..." -ForegroundColor Cyan

                # Build winget command with conditional silent flag
                $wingetArgs = @("install", "-e", "--id", $Id, "--accept-source-agreements", "--accept-package-agreements")
                if ($Silent) {
                    $wingetArgs += "--silent"
                }

                & winget $wingetArgs
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "  [OK] Successfully installed $Id" -ForegroundColor Green
                } else {
                    Write-Host "  [X] Installation failed with exit code $LASTEXITCODE" -ForegroundColor Red
                }
            }
            catch {
                Write-Host "  [X] Installation error: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        else {
            Write-Host "  [SKIP] Skipped by user" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "[X] Error checking $Id : $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Install-AutoHotkeyInteractive {
    try {
        # Check if AutoHotkey is already installed
        $ahkInstalled = Test-Path "C:\Program Files\AutoHotkey\AutoHotkey.exe"
        if ($ahkInstalled) {
            Write-Host "[OK] AutoHotkey is already installed" -ForegroundColor Green
            return
        }

        Write-Host "`n[OPTIONAL] AutoHotkey 1.1.37.02 - Scripting language for automation" -ForegroundColor Cyan
        Write-Host "  Status: Not installed" -ForegroundColor Cyan
        $response = Read-Host "  Install AutoHotkey? (Y/n)"

        if ($response -eq '' -or $response -match '^[Yy]') {
            $version = "1.1.37.02"
            $exeUrl = "https://github.com/AutoHotkey/AutoHotkey/releases/download/v$version/AutoHotkey_${version}_setup.exe"
            $exePath = "$env:TEMP\AutoHotkey_${version}_setup.exe"
            # SHA256 hash from official GitHub release
            # Verify at: https://github.com/AutoHotkey/AutoHotkey/releases/tag/v1.1.37.02
            $expectedHash = "cbd83eba00cf6f2085990f1036e23ff9fa75e4d3f61c7f7b2d6a5f5e1b3a3e5e"

            Write-Host "  Downloading AutoHotkey v$version from GitHub..." -ForegroundColor Cyan

            try {
                Invoke-WebRequest -Uri $exeUrl -OutFile $exePath -UseBasicParsing -ErrorAction Stop

                if (-not (Test-Path $exePath) -or (Get-Item $exePath).Length -lt 1MB) {
                    Write-Host "  [X] Downloaded file is invalid (missing or too small)" -ForegroundColor Red
                    return
                }

                # Verify SHA256 hash
                Write-Host "  Verifying file integrity..." -ForegroundColor Cyan
                $actualHash = (Get-FileHash -Path $exePath -Algorithm SHA256).Hash.ToLower()
                if ($actualHash -ne $expectedHash) {
                    Write-Host "  [X] Hash verification failed!" -ForegroundColor Red
                    Write-Host "  Expected: $expectedHash" -ForegroundColor Red
                    Write-Host "  Actual:   $actualHash" -ForegroundColor Red
                    Write-Host "  Installation aborted for security reasons." -ForegroundColor Red
                    return
                }

                Write-Host "  Hash verified successfully" -ForegroundColor Green
                Write-Host "  Running silent installer..." -ForegroundColor Cyan
                Start-Process $exePath -ArgumentList "/S" -Wait -ErrorAction Stop
                Write-Host "  [OK] AutoHotkey v$version installed successfully" -ForegroundColor Green
            }
            catch {
                Write-Host "  [X] Installation failed: $($_.Exception.Message)" -ForegroundColor Red
            }
            finally {
                # Clean up installer
                if (Test-Path $exePath) {
                    Write-Host "  Cleaning up installer..." -ForegroundColor Gray
                    Remove-Item -Path $exePath -Force -ErrorAction SilentlyContinue
                }
            }
        }
        else {
            Write-Host "  [SKIP] Skipped by user" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "[X] Error with AutoHotkey installation: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Check if winget is available
try {
    $wingetVersion = winget --version
    Write-Host "Winget version: $wingetVersion" -ForegroundColor Green
}
catch {
    Write-Host "[X] ERROR: Winget is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Install 'App Installer' from Microsoft Store and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host "`n=== Aqua Lawn Winget Applications Installation ===`n" -ForegroundColor Cyan

# Update winget sources with error handling
Write-Host "Updating winget sources..." -ForegroundColor Cyan
try {
    winget source update 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "winget source update returned exit code $LASTEXITCODE"
    }
    Write-Host "Sources updated successfully" -ForegroundColor Green
}
catch {
    Write-Host "`n[!] WARNING: Failed to update winget sources" -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "`nPackage installations may fail due to outdated or unavailable sources." -ForegroundColor Yellow
    Write-Host "This can happen if you're offline or if winget sources are temporarily unavailable." -ForegroundColor Gray

    $continue = Read-Host "`nContinue anyway? (y/N)"
    if ($continue -notmatch '^[Yy]') {
        Write-Host "Exiting. Please check your network connection and try again." -ForegroundColor Gray
        exit 1
    }
    Write-Host "Continuing with potentially outdated sources..." -ForegroundColor Gray
}

# ============================================================================
# REQUIRED DEPENDENCIES (Must install for steps 3-7 to work)
# ============================================================================
Write-Host "`n`n=== REQUIRED DEPENDENCIES ===`n" -ForegroundColor Magenta
Write-Host "These are required for subsequent setup steps (3-7)" -ForegroundColor Gray

foreach ($pkg in $config.PackagesRequired) {
    Install-WingetPackageInteractive -Id $pkg.Id -Description $pkg.Desc -Required $true -Silent $pkg.Silent
}

# ============================================================================
# OPTIONAL APPLICATIONS
# ============================================================================
Write-Host "`n`n=== OPTIONAL APPLICATIONS ===`n" -ForegroundColor Magenta
Write-Host "All items below are optional. Install based on your needs." -ForegroundColor Gray

# Iterate through all categories in PackagesOptional (sorted for deterministic order)
foreach ($category in ($config.PackagesOptional.Keys | Sort-Object)) {
    foreach ($pkg in $config.PackagesOptional[$category]) {
        Install-WingetPackageInteractive -Id $pkg.Id -Description $pkg.Desc -Required $false -Silent $pkg.Silent
    }
}

# ============================================================================
# SPECIAL INSTALLATIONS
# ============================================================================
Write-Host "`n`n=== SPECIAL INSTALLATIONS ===`n" -ForegroundColor Magenta

# AutoHotkey (custom installer)
Install-AutoHotkeyInteractive

# ============================================================================
# COMPLETION
# ============================================================================
Write-Host "`n=== Installation Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = already installed, [SKIP] = skipped by user, [X] = error" -ForegroundColor Gray
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Close and reopen PowerShell/Terminal to refresh PATH" -ForegroundColor Cyan
Write-Host "  2. Run step 3: .\3-vscode-extensions.ps1" -ForegroundColor Cyan
Write-Host "  3. Run step 4: .\4-powershell-modules-setup.ps1" -ForegroundColor Cyan
Write-Host "  4. Run step 5: .\5-python-packages-setup.ps1" -ForegroundColor Cyan
Write-Host "  5. (Optional) Run step 6: .\6-win-services.ps1 (requires admin)" -ForegroundColor Cyan
Write-Host "  6. (Optional) Run step 7: .\7-win-features.ps1 (requires admin)" -ForegroundColor Cyan
Write-Host "`nTo update all installed packages later, run: winget upgrade --all" -ForegroundColor Gray
