# ==================================================================
# PowerShell Modules Configuration
# Centralized configuration for PowerShell modules baseline
# Used by: 4-powershell-modules-setup.ps1
# Last updated: 2025-11-08
# ==================================================================

@{
    # ================================================================
    # CORE MODULES (installed by default)
    # ================================================================
    ModulesCore = @(
        @{Name="ImportExcel";        SkipPublisherCheck=$false; Desc="Excel file manipulation"}
        @{Name="dbatools";           SkipPublisherCheck=$false; Desc="SQL Server database tools"}
        @{Name="PSWindowsUpdate";    SkipPublisherCheck=$false; Desc="Windows Update management"}
        @{Name="BurntToast";         SkipPublisherCheck=$false; Desc="Windows 10 toast notifications"}
        @{Name="PSWriteHTML";        SkipPublisherCheck=$false; Desc="Generate HTML reports"}
        @{Name="Pester";             SkipPublisherCheck=$true;  Desc="Testing framework"}
        @{Name="posh-git";           SkipPublisherCheck=$false; Desc="Git integration for PowerShell"}
        @{Name="SqlServer";          SkipPublisherCheck=$false; Desc="SQL Server cmdlets"}
    )

    # ================================================================
    # OPTIONAL MODULES (install based on needs)
    # ================================================================
    ModulesOptional = @(
        @{Name="Az";              SkipPublisherCheck=$false; Desc="Azure"; Enabled=$false}
        @{Name="Microsoft.Graph"; SkipPublisherCheck=$false; Desc="Microsoft 365 / Graph"; Enabled=$false}
        @{Name="PSSlack";         SkipPublisherCheck=$false; Desc="Slack integration"; Enabled=$false}
        @{Name="PowerShellAI";    SkipPublisherCheck=$false; Desc="OpenAI from PowerShell"; Enabled=$false}
    )
}
