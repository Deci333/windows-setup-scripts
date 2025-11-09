# ==================================================================
# Winget Packages Configuration
# Centralized configuration for winget packages baseline
# Used by: 2-winget-development.ps1
# Last updated: 2025-11-08
# ==================================================================

@{
    # ================================================================
    # REQUIRED DEPENDENCIES (Must install for steps 3-5 to work)
    # ================================================================
    PackagesRequired = @(
        @{Id="Microsoft.VisualStudioCode";  Desc="VS Code - Required for step 3 (extensions)"; Silent=$true}
        @{Id="Microsoft.PowerShell";        Desc="PowerShell 7+ - Required for step 4 (modules)"; Silent=$true}
        @{Id="Python.Python.3.12";          Desc="Python 3.12 - Required for step 5 (packages)"; Silent=$true}
        @{Id="Python.Launcher";             Desc="Python Launcher (py command)"; Silent=$true}
    )

    # ================================================================
    # OPTIONAL PACKAGES (organized by category)
    # ================================================================
    PackagesOptional = @{
        CoreDevelopment = @(
            @{Id="Git.Git";                                    Desc="Git version control"; Silent=$true}
            @{Id="GitHub.GitHubDesktop";                       Desc="GitHub Desktop GUI"; Silent=$true}
            @{Id="Notepad++.Notepad++";                        Desc="Advanced text editor"; Silent=$true}
        )

        Programming = @(
            @{Id="OpenJS.NodeJS.LTS";                          Desc="Node.js LTS runtime"; Silent=$true}
            @{Id="Microsoft.DotNet.SDK.8";                     Desc=".NET SDK 8"; Silent=$true}
            @{Id="Microsoft.DotNet.SDK.9";                     Desc=".NET SDK 9"; Silent=$true}
        )

        AI = @(
            @{Id="Anthropic.Claude";                           Desc="Claude AI desktop app"; Silent=$true}
            @{Id="Ollama.Ollama";                              Desc="Local LLM runtime"; Silent=$true}
        )

        Database = @(
            @{Id="Microsoft.SQLServerManagementStudio";        Desc="SQL Server Management Studio"; Silent=$true}
            @{Id="Microsoft.msodbcsql.17";                     Desc="SQL Server ODBC Driver 17"; Silent=$true}
            @{Id="Microsoft.CLRTypesSQLServer.2019";           Desc="SQL Server CLR Types"; Silent=$true}
        )

        Containers = @(
            @{Id="Docker.DockerDesktop";                       Desc="Docker Desktop (requires WSL2)"; Silent=$true}
        )

        AdvancedDevelopment = @(
            @{Id="Microsoft.VisualStudio.2022.Community";      Desc="Visual Studio 2022 Community"; Silent=$true}
            @{Id="Microsoft.VSTOR";                            Desc="Visual Studio Tools for Office Runtime"; Silent=$true}
            @{Id="Microsoft.WebDeploy";                        Desc="Web Deploy for IIS"; Silent=$true}
        )

        Utilities = @(
            @{Id="7zip.7zip";                                  Desc="7-Zip file archiver"; Silent=$true}
            @{Id="voidtools.Everything";                       Desc="Everything search tool"; Silent=$true}
            @{Id="WinDirStat.WinDirStat";                      Desc="WinDirStat disk usage analyzer"; Silent=$true}
            @{Id="ShareX.ShareX";                              Desc="ShareX screenshot/screen recording"; Silent=$true}
            @{Id="VideoLAN.VLC";                               Desc="VLC media player"; Silent=$true}
            @{Id="Adobe.Acrobat.Reader.64-bit";                Desc="Adobe Acrobat Reader"; Silent=$true}
            @{Id="CPUID.CPU-Z";                                Desc="CPU-Z hardware info"; Silent=$true}
        )

        Security = @(
            @{Id="KeePassXCTeam.KeePassXC";                    Desc="KeePassXC password manager"; Silent=$true}
            @{Id="WiresharkFoundation.Wireshark";              Desc="Wireshark network analyzer"; Silent=$true}
            @{Id="Malwarebytes.Malwarebytes";                  Desc="Malwarebytes anti-malware"; Silent=$true}
            @{Id="Proton.ProtonVPN";                           Desc="ProtonVPN"; Silent=$true}
        )

        RemoteAccess = @(
            @{Id="AnyDesk.AnyDesk";                            Desc="AnyDesk remote desktop"; Silent=$true}
        )

        Media = @(
            @{Id="OBSProject.OBSStudio";                       Desc="OBS Studio streaming/recording"; Silent=$true}
            @{Id="Spotify.Spotify";                            Desc="Spotify music"; Silent=$true}
            @{Id="Valve.Steam";                                Desc="Steam gaming platform"; Silent=$true}
            @{Id="Discord.Discord";                            Desc="Discord communication"; Silent=$true}
        )

        Runtimes = @(
            @{Id="Microsoft.DotNet.DesktopRuntime.8";          Desc=".NET Desktop Runtime 8"; Silent=$true}
            @{Id="Microsoft.DotNet.DesktopRuntime.9";          Desc=".NET Desktop Runtime 9"; Silent=$true}
            @{Id="Microsoft.VCRedist.2015+.x64";               Desc="Visual C++ Redistributable"; Silent=$true}
            @{Id="Microsoft.UI.Xaml.2.7";                      Desc="WinUI 2.7"; Silent=$true}
            @{Id="Microsoft.UI.Xaml.2.8";                      Desc="WinUI 2.8"; Silent=$true}
        )

        SystemUtilities = @(
            @{Id="Microsoft.PowerToys";                        Desc="PowerToys utilities"; Silent=$true}
            @{Id="Microsoft.WindowsTerminal";                  Desc="Windows Terminal"; Silent=$true}
            @{Id="Microsoft.Sysinternals.Suite";               Desc="Sysinternals Suite"; Silent=$true}
        )
    }
}
