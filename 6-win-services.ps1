# ==================================================================
# Aqua Lawn - Windows Services Interactive Configuration
# Checks current service state and prompts for changes
# Run in elevated PowerShell (Run as Administrator)
# .\6-win-services.ps1
# Last updated: 2025-11-08
# ==================================================================

function Set-ServiceInteractive {
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

        $desc = if ($Description) { " - $Description" } else { "" }

        if ($startupMatch -and $statusMatch) {
            Write-Host "[OK] $Name is already configured correctly: $actualStartup / $actualStatus$desc" -ForegroundColor Green
            return
        }

        # Service needs changes - prompt user
        $expected = if ($ExpectedStatus) { "$ExpectedStartup / $ExpectedStatus" } else { $ExpectedStartup }
        Write-Host "`n[!] $Name$desc" -ForegroundColor Yellow
        Write-Host "  Current:  $actualStartup / $actualStatus" -ForegroundColor Cyan
        Write-Host "  Expected: $expected" -ForegroundColor Cyan

        $response = Read-Host "  Apply change? (Y/n)"

        if ($response -eq '' -or $response -match '^[Yy]') {
            try {
                # Set startup type
                Set-Service -Name $Name -StartupType $ExpectedStartup -ErrorAction Stop

                # Handle status changes for disabled services
                if ($ExpectedStartup -eq "Disabled" -and $actualStatus -eq "Running") {
                    Stop-Service -Name $Name -ErrorAction Stop
                    Write-Host "  [OK] Changed to $ExpectedStartup and stopped" -ForegroundColor Green
                }
                # Start service if expected to be running
                elseif ($ExpectedStatus -eq "Running" -and $actualStatus -ne "Running") {
                    Start-Service -Name $Name -ErrorAction Stop
                    Write-Host "  [OK] Changed to $ExpectedStartup and started" -ForegroundColor Green
                }
                else {
                    Write-Host "  [OK] Changed to $ExpectedStartup" -ForegroundColor Green
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
        Write-Host "[X] $Name - Not found or access denied$desc" -ForegroundColor Red
    }
}

# Check if running as Administrator
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "`n[!] WARNING: Not running as Administrator" -ForegroundColor Yellow
    Write-Host "Some operations may fail. Please run PowerShell as Administrator." -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -notmatch '^[Yy]') {
        Write-Host "Exiting..." -ForegroundColor Gray
        exit
    }
}

Write-Host "`n=== Aqua Lawn Windows Services Configuration ===`n" -ForegroundColor Cyan

# ================================================================
# Services expected: Automatic (Running)
# ================================================================
$shouldBeAutomatic = @(
    @{Name="Spooler";   Desc="Print Spooler"},
    @{Name="stisvc";    Desc="Windows Image Acquisition (scanners)"},
    @{Name="WebClient"; Desc="WebDAV Redirector (SharePoint/OneDrive)"},
    @{Name="WSearch";   Desc="Windows Search"},
    @{Name="BITS";      Desc="Background Intelligent Transfer Service"},
    @{Name="Schedule";  Desc="Task Scheduler"},
    @{Name="W32Time";   Desc="Windows Time"},
    @{Name="Winmgmt";   Desc="Windows Management Instrumentation"},
    @{Name="wuauserv";  Desc="Windows Update"}
)

Write-Host "`nChecking services that should be: Automatic / Running`n" -ForegroundColor Magenta
foreach ($s in $shouldBeAutomatic) {
    Set-ServiceInteractive -Name $s.Name -ExpectedStartup "Automatic" -ExpectedStatus "Running" -Description $s.Desc
}

# ================================================================
# Services expected: Manual
# ================================================================
$shouldBeManual = @(
    @{Name="msiserver"; Desc="Windows Installer"},
    @{Name="WerSvc";    Desc="Windows Error Reporting"}
)

Write-Host "`n`nChecking services that should be: Manual`n" -ForegroundColor Magenta
foreach ($s in $shouldBeManual) {
    Set-ServiceInteractive -Name $s.Name -ExpectedStartup "Manual" -Description $s.Desc
}

# ================================================================
# Services expected: Disabled (Stopped)
# ================================================================
$shouldBeDisabled = @(
    @{Name="RemoteAccess";    Desc="Routing and Remote Access (security risk)"},
    @{Name="RemoteRegistry";  Desc="Remote Registry (security risk)"}
)

Write-Host "`n`nChecking services that should be: Disabled / Stopped`n" -ForegroundColor Magenta
foreach ($s in $shouldBeDisabled) {
    Set-ServiceInteractive -Name $s.Name -ExpectedStartup "Disabled" -ExpectedStatus "Stopped" -Description $s.Desc
}

Write-Host "`n=== Configuration Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = already correct, [!] = prompted for change, [SKIP] = skipped by user, [X] = not found/error" -ForegroundColor Gray
Write-Host "Run 6-audit-win-services.ps1 to verify the current configuration" -ForegroundColor Gray