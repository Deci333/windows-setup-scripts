# ==================================================================
# Windows Features Audit (No Changes)
# STEP 7 OF 7 (AUDIT MODE - OPTIONAL): View-only mode for 7-win-features.ps1
# Checks current feature state against recommended baseline
# Configuration: config/win-features.psd1
# Admin rights required
# .\7-audit-win-features.ps1
# Last updated: 2025-11-08
# ==================================================================

# Load centralized configuration
$configPath = Join-Path $PSScriptRoot "config\win-features.psd1"
if (-not (Test-Path $configPath)) {
    Write-Host "[X] ERROR: Configuration file not found: $configPath" -ForegroundColor Red
    Write-Host "Please ensure config\win-features.psd1 exists" -ForegroundColor Yellow
    exit 1
}
$config = Import-PowerShellDataFile -Path $configPath

function Show-Result {
    param(
        [string]$Name,
        [string]$Expected,
        [string]$Description = ""
    )

    try {
        $info = Get-WindowsOptionalFeature -Online -FeatureName $Name -ErrorAction Stop
        $status = $info.State
        $match = ($status -eq $Expected)

        if ($match) {
            $color = "Green"
            $icon = "[OK]"
        } else {
            $color = "Yellow"
            $icon = "[!]"
        }

        $desc = if ($Description) { " - $Description" } else { "" }
        Write-Host ("{0} {1,-45} {2,-10} (expected {3}){4}" -f $icon, $Name, $status, $Expected, $desc) -ForegroundColor $color
    }
    catch {
        Write-Host ("[?] {0,-45} Not found / skipped" -f $Name) -ForegroundColor DarkGray
    }
}

Write-Host "`n=== Aqua Lawn Windows Feature Audit ===`n" -ForegroundColor Cyan

# ================================================================
# Features expected to be ENABLED
# ================================================================
Write-Host "`nExpected: ENABLED`n" -ForegroundColor Magenta
foreach ($f in $config.FeaturesEnabled) {
    Show-Result -Name $f.Name -Expected "Enabled" -Description $f.Desc
}

# ================================================================
# Features expected to be DISABLED
# ================================================================
Write-Host "`nExpected: DISABLED`n" -ForegroundColor Magenta
foreach ($f in $config.FeaturesDisabled) {
    Show-Result -Name $f.Name -Expected "Disabled" -Description $f.Desc
}

Write-Host "`n=== Audit Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = matches expected state, [!] = differs from expected, [?] = not found" -ForegroundColor Gray
Write-Host "Run 7-win-features.ps1 (as Administrator) to apply the baseline configuration" -ForegroundColor Gray
