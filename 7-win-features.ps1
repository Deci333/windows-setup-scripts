# ==================================================================
# Aqua Lawn - Windows Features Interactive Configuration
# Checks current feature state and prompts for changes
# Run as Administrator
# .\7-win-features.ps1
# Last updated: 2025-11-08
# ==================================================================

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
$shouldBeEnabled = @(
    @{Name="NetFx3";                                 Desc=".NET Framework 3.5"},
    @{Name="NetFx4-AdvSrvs";                         Desc=".NET Framework 4.8 Advanced Services"},
    @{Name="Printing-PrintToPDFServices-Features";   Desc="Microsoft Print to PDF"},
    @{Name="Printing-XPSServices-Features";          Desc="Microsoft XPS Document Writer"},
    @{Name="VirtualMachinePlatform";                 Desc="Virtual Machine Platform (WSL2/Hyper-V)"},
    @{Name="Microsoft-Hyper-V-All";                  Desc="Hyper-V virtualization"},
    @{Name="Microsoft-Windows-Subsystem-Linux";      Desc="Windows Subsystem for Linux"},
    @{Name="Windows-Defender-ApplicationGuard";      Desc="Application Guard security isolation"},
    @{Name="Windows-Defender-Credential-Guard";      Desc="Credential Guard protection"},
    @{Name="Containers-DisposableClientVM";          Desc="Windows Sandbox"},
    @{Name="WebDAV-Redirector";                      Desc="WebDAV client for network drives"}
)

Write-Host "`nChecking features that should be: ENABLED`n" -ForegroundColor Magenta
foreach ($f in $shouldBeEnabled) {
    Set-FeatureInteractive -Name $f.Name -ExpectedState "Enabled" -Description $f.Desc
}

# ================================================================
# Features expected to be DISABLED
# ================================================================
$shouldBeDisabled = @(
    @{Name="SMB1Protocol";                         Desc="SMB 1.0 protocol (security risk)"},
    @{Name="TelnetClient";                         Desc="Telnet client (insecure)"},
    @{Name="TFTP";                                 Desc="TFTP client"},
    @{Name="SimpleTCP";                            Desc="Simple TCP/IP services"},
    @{Name="MediaPlayback";                        Desc="Windows Media Playback"},
    @{Name="WindowsMediaPlayer";                   Desc="Windows Media Player (legacy)"},
    @{Name="XPS-Viewer";                           Desc="XPS Viewer"},
    @{Name="TabletPCMath";                         Desc="Math Recognition (Tablet PC)"},
    @{Name="IIS-WebServerRole";                    Desc="Internet Information Services"},
    @{Name="IIS-WebServer";                        Desc="IIS Web Server"},
    @{Name="IIS-CommonHttpFeatures";               Desc="IIS Common HTTP Features"},
    @{Name="IIS-HttpErrors";                       Desc="IIS HTTP Errors"},
    @{Name="IIS-ApplicationDevelopment";           Desc="IIS Application Development"},
    @{Name="IIS-NetFxExtensibility45";             Desc="IIS .NET Extensibility 4.5"},
    @{Name="IIS-HealthAndDiagnostics";             Desc="IIS Health and Diagnostics"},
    @{Name="IIS-HttpLogging";                      Desc="IIS HTTP Logging"},
    @{Name="IIS-Security";                         Desc="IIS Security"},
    @{Name="IIS-RequestFiltering";                 Desc="IIS Request Filtering"},
    @{Name="IIS-Performance";                      Desc="IIS Performance Features"},
    @{Name="IIS-WebServerManagementTools";         Desc="IIS Management Tools"},
    @{Name="IIS-ManagementConsole";                Desc="IIS Management Console"},
    @{Name="IIS-WebSockets";                       Desc="IIS WebSocket Protocol"},
    @{Name="IIS-ASPNET45";                         Desc="IIS ASP.NET 4.5"},
    @{Name="DirectPlay";                           Desc="DirectPlay (legacy gaming)"},
    @{Name="ServicesForNFS-ServerAndClient";       Desc="Network File System services"}
)

Write-Host "`n`nChecking features that should be: DISABLED`n" -ForegroundColor Magenta
foreach ($f in $shouldBeDisabled) {
    Set-FeatureInteractive -Name $f.Name -ExpectedState "Disabled" -Description $f.Desc
}

Write-Host "`n=== Configuration Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = already correct, [!] = prompted for change, [SKIP] = skipped by user, [X] = error, [?] = not found" -ForegroundColor Gray
Write-Host "IMPORTANT: Restart your computer to finalize feature changes" -ForegroundColor Yellow
Write-Host "Run 7-audit-win-features.ps1 to verify the current configuration" -ForegroundColor Gray
