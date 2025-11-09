# ==================================================================
# Windows Services Configuration
# Centralized configuration for Windows services baseline
# Used by: 6-audit-win-services.ps1, 6-win-services.ps1
# Last updated: 2025-11-08
# ==================================================================

@{
    # ================================================================
    # Services expected: Automatic (Running)
    # ================================================================
    ServicesAutomatic = @(
        @{Name="Spooler";   Desc="Print Spooler"}
        @{Name="stisvc";    Desc="Windows Image Acquisition (scanners)"}
        @{Name="WebClient"; Desc="WebDAV Redirector (SharePoint/OneDrive)"}
        @{Name="WSearch";   Desc="Windows Search"}
        @{Name="BITS";      Desc="Background Intelligent Transfer Service"}
        @{Name="Schedule";  Desc="Task Scheduler"}
        @{Name="W32Time";   Desc="Windows Time"}
        @{Name="Winmgmt";   Desc="Windows Management Instrumentation"}
        @{Name="wuauserv";  Desc="Windows Update"}
    )

    # ================================================================
    # Services expected: Manual
    # ================================================================
    ServicesManual = @(
        @{Name="msiserver"; Desc="Windows Installer"}
        @{Name="WerSvc";    Desc="Windows Error Reporting"}
    )

    # ================================================================
    # Services expected: Disabled (Stopped)
    # ================================================================
    ServicesDisabled = @(
        @{Name="RemoteAccess";    Desc="Routing and Remote Access (security risk)"}
        @{Name="RemoteRegistry";  Desc="Remote Registry (security risk)"}
    )
}
