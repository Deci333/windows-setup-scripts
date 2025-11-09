# ==================================================================
# VS Code Extensions Interactive Installation
# Checks if extensions are installed and prompts for installation
# STEP 3
# Run in PowerShell (admin NOT required)
# Configuration: config/vscode-extensions.psd1
# .\3-vscode-extensions.ps1
# Last updated: 2025-11-09
# ==================================================================

# Load centralized configuration
$configPath = Join-Path $PSScriptRoot "config\vscode-extensions.psd1"
if (-not (Test-Path $configPath)) {
    Write-Host "[X] ERROR: Configuration file not found: $configPath" -ForegroundColor Red
    Write-Host "Please ensure config\vscode-extensions.psd1 exists" -ForegroundColor Yellow
    exit 1
}
$config = Import-PowerShellDataFile -Path $configPath

# === PREREQUISITES ===
# 1. VS Code must be installed first
#    Install via: winget install -e --id Microsoft.VisualStudioCode
#    Or run step 2 (2-winget-development.ps1) which includes VS Code
# 2. You may need to close and reopen your terminal after installing VS Code
#    to ensure the 'code' command is available in your PATH
# 3. This script does NOT require administrator privileges

function Install-VSCodeExtensionInteractive {
    param(
        [string]$Id,
        [string]$Description = "",
        [bool]$Required = $false,
        [System.Collections.Generic.HashSet[string]]$InstalledExtensions
    )

    $desc = if ($Description) { " - $Description" } else { "" }
    $reqLabel = if ($Required) { "[REQUIRED]" } else { "[OPTIONAL]" }

    try {
        # Check if already installed (case-insensitive)
        $isInstalled = $InstalledExtensions.Contains($Id.ToLower())

        if ($isInstalled) {
            Write-Host "[OK] $Id is already installed$desc" -ForegroundColor Green
            return
        }

        # Extension not installed - prompt user
        Write-Host "`n$reqLabel $Id$desc" -ForegroundColor $(if ($Required) { "Yellow" } else { "Cyan" })
        Write-Host "  Status: Not installed" -ForegroundColor Cyan

        $response = Read-Host "  Install this extension? (Y/n)"

        if ($response -eq '' -or $response -match '^[Yy]') {
            try {
                Write-Host "  Installing $Id..." -ForegroundColor Cyan
                $output = code --install-extension $Id 2>&1

                if ($LASTEXITCODE -eq 0) {
                    Write-Host "  [OK] Successfully installed $Id" -ForegroundColor Green
                    # Update cache so we don't prompt again if extension appears in multiple categories
                    $InstalledExtensions.Add($Id.ToLower()) | Out-Null
                } else {
                    Write-Host "  [X] Installation failed with exit code $LASTEXITCODE" -ForegroundColor Red
                    if ($output) {
                        Write-Host "  Error details: $output" -ForegroundColor Red
                    }
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

# Check if VS Code is available
try {
    $codeVersionOutput = code --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "VS Code command failed"
    }
    Write-Host "VS Code version:" -ForegroundColor Green
    $codeVersionOutput | ForEach-Object { Write-Host "  $_" -ForegroundColor Green }
}
catch {
    Write-Host "`n[X] ERROR: VS Code is not installed or 'code' command not in PATH" -ForegroundColor Red
    Write-Host "Please install VS Code first:" -ForegroundColor Yellow
    Write-Host "  winget install -e --id Microsoft.VisualStudioCode" -ForegroundColor Cyan
    Write-Host "`nIf VS Code is installed, close and reopen your terminal to refresh PATH" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n=== Aqua Lawn VS Code Extensions Installation ===`n" -ForegroundColor Cyan

# Cache installed extensions list for performance (called once instead of 50+ times)
Write-Host "Loading currently installed extensions..." -ForegroundColor Cyan
$installedExtensionsList = code --list-extensions 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[X] Failed to list installed extensions" -ForegroundColor Red
    if ($installedExtensionsList) {
        Write-Host "Error details: $installedExtensionsList" -ForegroundColor Red
    }
    Write-Host "This usually means VS Code is not in PATH or the 'code' command is unavailable" -ForegroundColor Yellow
    exit 1
}

# Convert to lowercase HashSet for fast case-insensitive lookups
$installedExtensionsSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($ext in $installedExtensionsList) {
    $installedExtensionsSet.Add($ext.ToLower()) | Out-Null
}
Write-Host "Found $($installedExtensionsSet.Count) installed extension(s)" -ForegroundColor Green

# ============================================================================
# AI & COPILOT
# ============================================================================
Write-Host "`n=== AI & COPILOT ===`n" -ForegroundColor Magenta

foreach ($ext in $config.AI) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# PYTHON DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== PYTHON DEVELOPMENT ===`n" -ForegroundColor Magenta

foreach ($ext in $config.Python) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# C# / .NET DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== C# / .NET DEVELOPMENT ===`n" -ForegroundColor Magenta

foreach ($ext in $config.CSharp) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# JAVA DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== JAVA DEVELOPMENT ===`n" -ForegroundColor Magenta

foreach ($ext in $config.Java) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# SQL / DATABASE
# ============================================================================
Write-Host "`n`n=== SQL / DATABASE ===`n" -ForegroundColor Magenta

foreach ($ext in $config.SQL) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# C/C++ DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== C/C++ DEVELOPMENT ===`n" -ForegroundColor Magenta

foreach ($ext in $config.CPP) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# REMOTE DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== REMOTE DEVELOPMENT ===`n" -ForegroundColor Magenta

foreach ($ext in $config.RemoteDevelopment) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# CONTAINERS & KUBERNETES
# ============================================================================
Write-Host "`n`n=== CONTAINERS & KUBERNETES ===`n" -ForegroundColor Magenta

foreach ($ext in $config.Containers) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# AUTOHOTKEY
# ============================================================================
Write-Host "`n`n=== AUTOHOTKEY ===`n" -ForegroundColor Magenta

foreach ($ext in $config.AutoHotkey) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# OTHER UTILITIES
# ============================================================================
Write-Host "`n`n=== OTHER UTILITIES ===`n" -ForegroundColor Magenta

foreach ($ext in $config.Utilities) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# COMPLETION
# ============================================================================
Write-Host "`n=== Installation Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = already installed, [SKIP] = skipped by user, [X] = error" -ForegroundColor Gray
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  - Reboot PC" -ForegroundColor Cyan
Write-Host "  - Open VS Code to activate all installed extensions" -ForegroundColor Cyan
Write-Host "  - Run Step 4: .\4-powershell-modules-setup.ps1" -ForegroundColor Cyan
Write-Host "`nTo view all installed extensions: code --list-extensions" -ForegroundColor Gray
