# ==================================================================
# Aqua Lawn - Windows Features Audit (No Changes)
# Checks current feature state against recommended baseline
# admin rights required
# .\7-audit-win-features.ps1
# Last updated: 2025-11-08
# ==================================================================

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
$shouldBeOn = @(
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

Write-Host "`nExpected: ENABLED`n" -ForegroundColor Magenta
foreach ($f in $shouldBeOn) {
    Show-Result -Name $f.Name -Expected "Enabled" -Description $f.Desc
}

# ================================================================
# Features expected to be DISABLED
# ================================================================
$shouldBeOff = @(
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

Write-Host "`nExpected: DISABLED`n" -ForegroundColor Magenta
foreach ($f in $shouldBeOff) {
    Show-Result -Name $f.Name -Expected "Disabled" -Description $f.Desc
}

Write-Host "`n=== Audit Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = matches expected state, [!] = differs from expected, [?] = not found" -ForegroundColor Gray
Write-Host "Run 7-win-features.ps1 (as Administrator) to apply the baseline configuration" -ForegroundColor Gray
