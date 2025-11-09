# ==================================================================
# Windows Features Interactive Configuration
# STEP 7
# Checks current feature state and prompts for changes
# Configuration: config/win-features.psd1
# Run as Administrator
# .\7-win-features.ps1
# Last updated: 2025-11-08
# to get list of your features and status - Run as administrator:
# Get-WindowsOptionalFeature -Online |
# Select-Object FeatureName, State |
# Export-Csv -Path "C:\WindowsFeatures.csv" -NoTypeInformation

# ==================================================================

# Load centralized configuration
$configPath = Join-Path $PSScriptRoot "config\win-features.psd1"
if (-not (Test-Path $configPath)) {
    Write-Host "[X] ERROR: Configuration file not found: $configPath" -ForegroundColor Red
    Write-Host "Please ensure config\win-features.psd1 exists" -ForegroundColor Yellow
    exit 1
}
$config = Import-PowerShellDataFile -Path $configPath

function Set-FeatureInteractive {
    param(
        [string]$Name,
        [string]$ExpectedState,
        [string]$Description = ""
    )

    try {
        $info = Get-WindowsOptionalFeature -Online -FeatureName $Name -ErrorAction Stop
        $actualState = $info.State

        $desc = if ($Description) { " - $Description" } else { "" }

        if ($actualState -eq $ExpectedState) {
            Write-Host "[OK] $Name is already configured correctly: $actualState$desc" -ForegroundColor Green
            return
        }

        # Feature needs changes - prompt user
        Write-Host "`n[!] $Name$desc" -ForegroundColor Yellow
        Write-Host "  Current:  $actualState" -ForegroundColor Cyan
        Write-Host "  Expected: $ExpectedState" -ForegroundColor Cyan

        $response = Read-Host "  Apply change? (Y/n)"

        if ($response -eq '' -or $response -match '^[Yy]') {
            try {
                if ($ExpectedState -eq "Enabled") {
                    Enable-WindowsOptionalFeature -Online -FeatureName $Name -All -NoRestart -ErrorAction Stop | Out-Null
                    Write-Host "  [OK] Enabled $Name (restart may be required)" -ForegroundColor Green
                }
                else {
                    Disable-WindowsOptionalFeature -Online -FeatureName $Name -NoRestart -ErrorAction Stop | Out-Null
                    Write-Host "  [OK] Disabled $Name (restart may be required)" -ForegroundColor Green
                }
            }
            catch {
                Write-Host "  [X] Failed to apply changes: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        else {
            Write-Host "  [SKIP] Skipped by user" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "[?] $Name - Not found (may not be available in this Windows edition)$desc" -ForegroundColor DarkGray
    }
}

# Check if running as Administrator
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "`n[!] WARNING: Not running as Administrator" -ForegroundColor Yellow
    Write-Host "Windows feature changes REQUIRE Administrator privileges." -ForegroundColor Yellow
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway to see what would change? (y/N)"
    if ($continue -notmatch '^[Yy]') {
        Write-Host "Exiting..." -ForegroundColor Gray
        exit
    }
}

Write-Host "`n=== Aqua Lawn Windows Features Configuration ===`n" -ForegroundColor Cyan

# ================================================================
# Features expected to be ENABLED
# ================================================================
Write-Host "`nChecking features that should be: ENABLED`n" -ForegroundColor Magenta
foreach ($f in $config.FeaturesEnabled) {
    Set-FeatureInteractive -Name $f.Name -ExpectedState "Enabled" -Description $f.Desc
}

# ================================================================
# Features expected to be DISABLED
# ================================================================
Write-Host "`n`nChecking features that should be: DISABLED`n" -ForegroundColor Magenta
foreach ($f in $config.FeaturesDisabled) {
    Set-FeatureInteractive -Name $f.Name -ExpectedState "Disabled" -Description $f.Desc
}

Write-Host "`n=== Configuration Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = already correct, [!] = prompted for change, [SKIP] = skipped by user, [X] = error, [?] = not found" -ForegroundColor Gray
Write-Host "IMPORTANT: Restart your computer to finalize feature changes" -ForegroundColor Yellow
Write-Host "Run 7-audit-win-features.ps1 to verify the current configuration" -ForegroundColor Gray
