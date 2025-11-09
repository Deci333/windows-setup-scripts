# ==================================================================
# Python Packages Interactive Installation
# Checks if packages are installed and prompts for installation
# STEP 5 OF 7: Run this file after completing steps 1-4
# Run in PowerShell (admin NOT required)
# Configuration: config/python-packages.psd1
# .\5-python-packages-setup.ps1
# Last updated: 2025-11-08
# ==================================================================

# Load centralized configuration
$configPath = Join-Path $PSScriptRoot "config\python-packages.psd1"
if (-not (Test-Path $configPath)) {
    Write-Host "[X] ERROR: Configuration file not found: $configPath" -ForegroundColor Red
    Write-Host "Please ensure config\python-packages.psd1 exists" -ForegroundColor Yellow
    exit 1
}
$config = Import-PowerShellDataFile -Path $configPath

# === PREREQUISITES ===
# 1. Python must be installed first
#    Install via: winget install -e --id Python.Python.3.12
#    Or run step 2 (2-winget-development.ps1) which includes Python
# 2. You may need to close and reopen your terminal after installing Python
#    to ensure the 'python'/'py' command is available in your PATH
# 3. This script does NOT require administrator privileges
# 4. Large ML packages (torch, transformers) require ~5-10GB disk space and take significant time to install

function Install-PythonPackageInteractive {
    param(
        [string]$Name,
        [string]$Version = "",
        [string]$Description = "",
        [bool]$Required = $false,
        [hashtable]$InstalledPackages,
        [object]$PythonCommand
    )

    $desc = if ($Description) { " - $Description" } else { "" }
    $reqLabel = if ($Required) { "[REQUIRED]" } else { "[OPTIONAL]" }

    try {
        # Check if already installed (case-insensitive)
        $packageKey = $Name.ToLower()
        $isInstalled = $InstalledPackages.ContainsKey($packageKey)

        if ($isInstalled) {
            $installedVersion = $InstalledPackages[$packageKey]

            # If specific version requested, compare versions
            if ($Version) {
                try {
                    $installedVer = [version]$installedVersion
                    $requiredVer = [version]$Version

                    if ($installedVer -ge $requiredVer) {
                        Write-Host "[OK] $Name is already installed (v$installedVersion >= v$Version)$desc" -ForegroundColor Green
                        return
                    }

                    # Version is outdated - prompt for upgrade
                    Write-Host "`n[!] $Name is outdated$desc" -ForegroundColor Yellow
                    Write-Host "  Installed: v$installedVersion" -ForegroundColor Cyan
                    Write-Host "  Required:  v$Version" -ForegroundColor Cyan
                    $upgradeResponse = Read-Host "  Upgrade this package? (Y/n)"

                    # Early return if user declines upgrade
                    if ($upgradeResponse -ne '' -and $upgradeResponse -notmatch '^[Yy]') {
                        Write-Host "  [SKIP] Upgrade declined by user" -ForegroundColor Gray
                        return
                    }
                    # If we reach here, user approved upgrade - fall through to installation
                }
                catch {
                    # Version comparison failed (non-numeric versions) - assume OK
                    Write-Host "[OK] $Name is already installed (v$installedVersion)$desc" -ForegroundColor Green
                    return
                }
            } else {
                # No specific version required - already installed is OK
                Write-Host "[OK] $Name is already installed (v$installedVersion)$desc" -ForegroundColor Green
                return
            }
        } else {
            # Package not installed - prompt user
            $versionInfo = if ($Version) { " (v$Version)" } else { " (latest)" }
            Write-Host "`n$reqLabel $Name$versionInfo$desc" -ForegroundColor $(if ($Required) { "Yellow" } else { "Cyan" })
            Write-Host "  Status: Not installed" -ForegroundColor Cyan

            $response = Read-Host "  Install this package? (Y/n)"

            # Early return if user declines installation
            if ($response -ne '' -and $response -notmatch '^[Yy]') {
                Write-Host "  [SKIP] Skipped by user" -ForegroundColor Gray
                return
            }
            # If we reach here, user approved installation - fall through
        }

        # At this point we know user approved (either upgrade or fresh install)
        # Proceed with installation
        Write-Host "  Installing $Name..." -ForegroundColor Cyan

        # Build pip install command
        $packageSpec = if ($Version) { "$Name==$Version" } else { $Name }

        # Handle both array (e.g., 'py', '-3') and string (e.g., 'python') cases
        if ($PythonCommand -is [array]) {
            $pythonExe = $PythonCommand[0]
            $pythonArgs = $PythonCommand[1..($PythonCommand.Length-1)]
            $output = & $pythonExe @pythonArgs -m pip install $packageSpec 2>&1
        } else {
            $output = & $PythonCommand -m pip install $packageSpec 2>&1
        }

        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Successfully installed $Name" -ForegroundColor Green
            # Update cache so we don't prompt again
            $InstalledPackages[$packageKey] = if ($Version) { $Version } else { "latest" }
        } else {
            Write-Host "  [X] Installation failed with exit code $LASTEXITCODE" -ForegroundColor Red
            if ($output) {
                # Show last few lines of error
                $errorLines = ($output | Select-Object -Last 5) -join "`n"
                Write-Host "  Error details: $errorLines" -ForegroundColor Red
            }
        }
    }
    catch {
        Write-Host "[X] Error checking $Name : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# ============================================================================
# PYTHON VALIDATION
# ============================================================================

Write-Host "`n=== Python Package Installation ===`n" -ForegroundColor Cyan

# Check for Python in multiple common forms
$pythonCmd = $null

if (Get-Command py -ErrorAction SilentlyContinue) {
    $pythonCmd = 'py', '-3'
    Write-Host "Found Python via 'py' launcher" -ForegroundColor Gray
}
elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
    $pythonCmd = 'python3'
    Write-Host "Found Python via 'python3' command" -ForegroundColor Gray
}
elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonCmd = 'python'
    Write-Host "Found Python via 'python' command" -ForegroundColor Gray
}

if (-not $pythonCmd) {
    Write-Host "`n[X] ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python first:" -ForegroundColor Yellow
    Write-Host "  winget install -e --id Python.Python.3.12" -ForegroundColor Cyan
    Write-Host "`nIf Python is installed, close and reopen your terminal to refresh PATH" -ForegroundColor Yellow
    exit 1
}

# Display Python version
try {
    if ($pythonCmd -is [array]) {
        $pythonExe = $pythonCmd[0]
        $pythonArgs = $pythonCmd[1..($pythonCmd.Length-1)]
        $pythonVersionOutput = & $pythonExe @pythonArgs --version 2>&1
    } else {
        $pythonVersionOutput = & $pythonCmd --version 2>&1
    }

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Python version: $pythonVersionOutput" -ForegroundColor Green
    } else {
        throw "Python command failed"
    }
}
catch {
    Write-Host "`n[X] ERROR: Failed to get Python version" -ForegroundColor Red
    exit 1
}

# ============================================================================
# CACHE INSTALLED PACKAGES
# ============================================================================

Write-Host "`nLoading currently installed packages..." -ForegroundColor Cyan

try {
    # Get installed packages list using pip list --format=json
    # --disable-pip-version-check prevents upgrade warnings from breaking JSON parsing
    if ($pythonCmd -is [array]) {
        $pythonExe = $pythonCmd[0]
        $pythonArgs = $pythonCmd[1..($pythonCmd.Length-1)]
        $pipListOutput = & $pythonExe @pythonArgs -m pip list --format=json --disable-pip-version-check 2>&1
    } else {
        $pipListOutput = & $pythonCmd -m pip list --format=json --disable-pip-version-check 2>&1
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[X] Failed to list installed packages" -ForegroundColor Red
        if ($pipListOutput) {
            Write-Host "Error details: $pipListOutput" -ForegroundColor Red
        }
        Write-Host "This usually means pip is not properly installed" -ForegroundColor Yellow
        exit 1
    }

    # Parse JSON and create hashtable (case-insensitive)
    $installedPackagesHash = @{}

    # Validate JSON output (should start with '[')
    $pipListOutputStr = $pipListOutput -join "`n"
    if ($pipListOutputStr -notmatch '^\s*\[') {
        Write-Host "[X] pip list output is not valid JSON" -ForegroundColor Red
        Write-Host "Output received:" -ForegroundColor Red
        Write-Host $pipListOutputStr -ForegroundColor Gray
        Write-Host "`nThis usually means pip emitted warnings or errors. Try running manually:" -ForegroundColor Yellow
        if ($pythonCmd -is [array]) {
            $cmdDisplay = $pythonCmd -join ' '
        } else {
            $cmdDisplay = $pythonCmd
        }
        Write-Host "  $cmdDisplay -m pip list --format=json --disable-pip-version-check" -ForegroundColor Cyan
        exit 1
    }

    $pipListJson = $pipListOutput | ConvertFrom-Json
    foreach ($pkg in $pipListJson) {
        $installedPackagesHash[$pkg.name.ToLower()] = $pkg.version
    }

    Write-Host "Found $($installedPackagesHash.Count) installed package(s)" -ForegroundColor Green
}
catch {
    Write-Host "[X] Error parsing installed packages: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# ============================================================================
# WEB AUTOMATION & SCRAPING
# ============================================================================
Write-Host "`n`n=== WEB AUTOMATION & SCRAPING ===`n" -ForegroundColor Magenta

foreach ($pkg in $config.WebAutomation) {
    Install-PythonPackageInteractive -Name $pkg.Name -Version $pkg.Version -Description $pkg.Desc -Required $false -InstalledPackages $installedPackagesHash -PythonCommand $pythonCmd
}

# ============================================================================
# DATA PROCESSING
# ============================================================================
Write-Host "`n`n=== DATA PROCESSING ===`n" -ForegroundColor Magenta

foreach ($pkg in $config.DataProcessing) {
    Install-PythonPackageInteractive -Name $pkg.Name -Version $pkg.Version -Description $pkg.Desc -Required $false -InstalledPackages $installedPackagesHash -PythonCommand $pythonCmd
}

# ============================================================================
# UTILITIES
# ============================================================================
Write-Host "`n`n=== UTILITIES ===`n" -ForegroundColor Magenta

foreach ($pkg in $config.Utilities) {
    Install-PythonPackageInteractive -Name $pkg.Name -Version $pkg.Version -Description $pkg.Desc -Required $false -InstalledPackages $installedPackagesHash -PythonCommand $pythonCmd
}

# ============================================================================
# MACHINE LEARNING (LARGE PACKAGES)
# ============================================================================
Write-Host "`n`n=== MACHINE LEARNING (LARGE PACKAGES - ~5-10GB) ===`n" -ForegroundColor Magenta
Write-Host "WARNING: These packages are very large and may take 10+ minutes to download/install" -ForegroundColor Yellow
Write-Host "Requires Python 3.10+ | torch 2.9.0 requires CUDA 12.8+ for GPU support" -ForegroundColor Gray

foreach ($pkg in $config.MachineLearning) {
    Install-PythonPackageInteractive -Name $pkg.Name -Version $pkg.Version -Description $pkg.Desc -Required $false -InstalledPackages $installedPackagesHash -PythonCommand $pythonCmd
}

# ============================================================================
# COMPLETION
# ============================================================================
Write-Host "`n=== Installation Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = already installed, [SKIP] = skipped by user, [X] = error" -ForegroundColor Gray
Write-Host "`nAll setup steps complete! Your development environment is ready." -ForegroundColor Green
Write-Host "`nTo upgrade packages later, run: pip install --upgrade package-name" -ForegroundColor Gray
Write-Host "To see all installed packages: pip list" -ForegroundColor Gray
