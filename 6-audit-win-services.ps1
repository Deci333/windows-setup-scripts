# ==================================================================
# Windows Services Audit (No Changes)
# STEP 6 - View-only mode for 6-win-services.ps1
# Checks current service state against recommended baseline
# Configuration: config/win-services.psd1
# Safe to run on any workstation (no admin rights required)
# .\6-audit-win-services.ps1
# Last updated: 2025-11-08
# ==================================================================

# Load centralized configuration
$configPath = Join-Path $PSScriptRoot "config\win-services.psd1"
if (-not (Test-Path $configPath)) {
    Write-Host "[X] ERROR: Configuration file not found: $configPath" -ForegroundColor Red
    Write-Host "Please ensure config\win-services.psd1 exists" -ForegroundColor Yellow
    exit 1
}
$config = Import-PowerShellDataFile -Path $configPath

function Show-ServiceResult {
    param(
        [string]$Name,
        [string]$ExpectedStartup,
        [string]$ExpectedStatus = "",
        [string]$Description = ""
    )

    try {
        $svc = Get-Service -Name $Name -ErrorAction Stop
        $actualStartup = (Get-Service -Name $Name | Select-Object -ExpandProperty StartType).ToString()
        $actualStatus = $svc.Status.ToString()

        # Determine if service matches expected state
        $startupMatch = ($actualStartup -eq $ExpectedStartup)
        $statusMatch = if ($ExpectedStatus) { $actualStatus -eq $ExpectedStatus } else { $true }

        if ($startupMatch -and $statusMatch) {
            $color = "Green"
            $icon = "[OK]"
        } else {
            $color = "Yellow"
            $icon = "[!]"
        }

        $expected = if ($ExpectedStatus) { "$ExpectedStartup/$ExpectedStatus" } else { $ExpectedStartup }
        $desc = if ($Description) { " - $Description" } else { "" }
        Write-Host ("{0} {1,-25} {2,-15} {3,-10} (expected {4}){5}" -f $icon, $Name, $actualStartup, $actualStatus, $expected, $desc) -ForegroundColor $color
    }
    catch {
        Write-Host ("[X] {0,-25} Not found or error" -f $Name) -ForegroundColor Red
    }
}

Write-Host "`n=== Aqua Lawn Windows Services Audit ===`n" -ForegroundColor Cyan

# ================================================================
# Services expected: Automatic (Running)
# ================================================================
Write-Host "`nExpected: Automatic / Running`n" -ForegroundColor Magenta
foreach ($s in $config.ServicesAutomatic) {
    Show-ServiceResult -Name $s.Name -ExpectedStartup "Automatic" -ExpectedStatus "Running" -Description $s.Desc
}

# ================================================================
# Services expected: Manual
# ================================================================
Write-Host "`nExpected: Manual`n" -ForegroundColor Magenta
foreach ($s in $config.ServicesManual) {
    Show-ServiceResult -Name $s.Name -ExpectedStartup "Manual" -Description $s.Desc
}

# ================================================================
# Services expected: Disabled (Stopped)
# ================================================================
Write-Host "`nExpected: Disabled / Stopped`n" -ForegroundColor Magenta
foreach ($s in $config.ServicesDisabled) {
    Show-ServiceResult -Name $s.Name -ExpectedStartup "Disabled" -ExpectedStatus "Stopped" -Description $s.Desc
}

Write-Host "`n=== Audit Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = matches expected state, [!] = differs from expected, [X] = not found" -ForegroundColor Gray
Write-Host "Run 6-win-services.ps1 (as Administrator) to apply the baseline configuration" -ForegroundColor Gray
Write-Host "Proceed to 7-win-features.ps1 (as Administrator)" -ForegroundColor Gray