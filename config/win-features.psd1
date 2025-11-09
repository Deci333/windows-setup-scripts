# ==================================================================
# Windows Features Configuration
# Centralized configuration for Windows features baseline
# Used by: 7-audit-win-features.ps1, 7-win-features.ps1
# Last updated: 2025-11-09
# ==================================================================

@{
    # ================================================================
    # Features expected to be ENABLED
    # ================================================================
    FeaturesEnabled = @(
        @{Name="NetFx3";                                 Desc=".NET Framework 3.5 (legacy Win32 and Line-of-Business apps)"}
        @{Name="NetFx4-AdvSrvs";                         Desc=".NET Framework 4.8 Advanced Services (modern desktop runtimes)"}
        @{Name="Printing-PrintToPDFServices-Features";   Desc="Microsoft Print to PDF (virtual PDF printer)"}
        @{Name="Printing-XPSServices-Features";          Desc="Microsoft XPS Document Writer (XPS virtual printer)"}
        @{Name="VirtualMachinePlatform";                 Desc="Virtual Machine Platform (required for WSL2/WSA/Hyper-V tooling)"}
        @{Name="Microsoft-Hyper-V-All";                  Desc="Hyper-V virtualization (VM hosting stack)"}
        @{Name="Microsoft-Windows-Subsystem-Linux";      Desc="Windows Subsystem for Linux (WSL runtime)"}
        @{Name="Containers-DisposableClientVM";          Desc="Windows Sandbox (disposable containerized desktop)"}
    )

    # ================================================================
    # Features expected to be DISABLED
    # ================================================================
    FeaturesDisabled = @(
        @{Name="SMB1Protocol";                         Desc="SMB 1.0 protocol (legacy file sharing attack surface)"}
        @{Name="TelnetClient";                         Desc="Telnet client (plaintext remote shell)"}
        @{Name="TFTP";                                 Desc="TFTP client (unauthenticated file transfer)"}
        @{Name="SimpleTCP";                            Desc="Simple TCP/IP services (unused legacy daemons)"}
        @{Name="MediaPlayback";                        Desc="Windows Media Playback (deprecated codec pack)"}
        @{Name="WindowsMediaPlayer";                   Desc="Windows Media Player (legacy media stack)"}
        @{Name="IIS-WebServerRole";                    Desc="Internet Information Services (not needed on workstations)"}
        @{Name="IIS-WebServer";                        Desc="IIS Web Server core (web hosting components)"}
        @{Name="IIS-CommonHttpFeatures";               Desc="IIS Common HTTP Features (static content modules)"}
        @{Name="IIS-HttpErrors";                       Desc="IIS HTTP Errors (custom error pages)"}
        @{Name="IIS-ApplicationDevelopment";           Desc="IIS Application Development (ASP/CGI modules)"}
        @{Name="IIS-NetFxExtensibility45";             Desc="IIS .NET Extensibility 4.5 (managed handlers)"}
        @{Name="IIS-HealthAndDiagnostics";             Desc="IIS Health and Diagnostics (logging, tracing)"}
        @{Name="IIS-HttpLogging";                      Desc="IIS HTTP Logging (IIS log writer)"}
        @{Name="IIS-Security";                         Desc="IIS Security (auth modules, filters)"}
        @{Name="IIS-RequestFiltering";                 Desc="IIS Request Filtering (URLScan successor)"}
        @{Name="IIS-Performance";                      Desc="IIS Performance Features (dynamic cache/compression)"}
        @{Name="IIS-WebServerManagementTools";         Desc="IIS Management Tools (manager UI + scripts)"}
        @{Name="IIS-ManagementConsole";                Desc="IIS Management Console (MMC snap-in)"}
        @{Name="IIS-WebSockets";                       Desc="IIS WebSocket Protocol (real-time web support)"}
        @{Name="IIS-ASPNET45";                         Desc="IIS ASP.NET 4.5 (server-side .NET runtime)"}
        @{Name="DirectPlay";                           Desc="DirectPlay (legacy DirectX networking APIs)"}
    )

    # ================================================================
    # NEW ADDITIONS - Review and categorize these features
    # Imported from WindowsFeatures.csv
    # These need to be reviewed and moved to appropriate categories above
    # ================================================================

    # Features currently Enabled (from CSV export)
    FeaturesEnabledNew = @(
        @{Name="WorkFolders-Client"; Desc="Work Folders sync client for on-prem file servers"}
        @{Name="WCF-Services45"; Desc="WCF HTTP services for .NET 4.5 workflows"}
        @{Name="WCF-TCP-PortSharing45"; Desc="WCF TCP port-sharing listener for .NET 4.5"}
        @{Name="SmbDirect"; Desc="SMB over RDMA high-performance file sharing"}
        @{Name="MSRDC-Infrastructure"; Desc="Modern Remote Desktop (MSRDC) client platform"}
        @{Name="SearchEngine-Client-Package"; Desc="Windows Search indexer and client components"}
        @{Name="Microsoft-RemoteDesktopConnection"; Desc="Legacy Remote Desktop Connection (mstsc) UI"}
        @{Name="Printing-Foundation-Features"; Desc="Core Windows printing pipeline components"}
        @{Name="Printing-Foundation-InternetPrinting-Client"; Desc="Internet Printing Protocol (IPP) client"}
        @{Name="Microsoft-Hyper-V"; Desc="Hyper-V role (parent partition components)"}
        @{Name="Microsoft-Hyper-V-Tools-All"; Desc="Hyper-V management tools (GUI and CLI)"}
        @{Name="Microsoft-Hyper-V-Management-PowerShell"; Desc="Hyper-V PowerShell management module"}
        @{Name="Microsoft-Hyper-V-Hypervisor"; Desc="Hyper-V hypervisor platform"}
        @{Name="Microsoft-Hyper-V-Services"; Desc="Hyper-V services that run VMs"}
        @{Name="Microsoft-Hyper-V-Management-Clients"; Desc="Hyper-V Manager MMC clients"}
        @{Name="Containers"; Desc="Windows container runtime platform"}
        @{Name="Containers-HNS"; Desc="Host Networking Service for containers"}
        @{Name="Containers-SDN"; Desc="Software-defined networking extensions for containers"}
    )

    # Features currently Disabled (from CSV export)
    FeaturesDisabledNew = @(
        @{Name="Windows-Defender-Default-Definitions"; Desc="Microsoft Defender default signature package (offline)"}
        @{Name="TIFFIFilter"; Desc="TIFF IFilter so Search can index scanned images"}
        @{Name="Client-ProjFS"; Desc="Projected File System client (virtualized file mounts)"}
        @{Name="WCF-HTTP-Activation"; Desc="WCF HTTP activation for older .NET apps"}
        @{Name="WCF-NonHTTP-Activation"; Desc="WCF MSMQ/pipe activation for older .NET apps"}
        @{Name="IIS-HttpRedirect"; Desc="IIS HTTP redirection module"}
        @{Name="IIS-NetFxExtensibility"; Desc="IIS .NET Extensibility 3.5 handlers"}
        @{Name="IIS-LoggingLibraries"; Desc="IIS custom logging libraries"}
        @{Name="IIS-RequestMonitor"; Desc="IIS worker process request monitor"}
        @{Name="IIS-HttpTracing"; Desc="IIS request tracing diagnostics"}
        @{Name="IIS-URLAuthorization"; Desc="IIS URL Authorization module"}
        @{Name="IIS-IPSecurity"; Desc="IIS IP/domain restrictions module"}
        @{Name="IIS-HttpCompressionDynamic"; Desc="IIS dynamic content compression"}
        @{Name="IIS-ManagementScriptingTools"; Desc="IIS management scripting tools and cmdlets"}
        @{Name="IIS-IIS6ManagementCompatibility"; Desc="IIS 6 management compatibility layer"}
        @{Name="IIS-Metabase"; Desc="IIS legacy metabase configuration store"}
        @{Name="WAS-WindowsActivationService"; Desc="Windows Process Activation Service core"}
        @{Name="WAS-ProcessModel"; Desc="WAS process model (worker control)"}
        @{Name="WAS-NetFxEnvironment"; Desc="WAS .NET Framework integration"}
        @{Name="WAS-ConfigurationAPI"; Desc="WAS configuration APIs"}
        @{Name="IIS-HostableWebCore"; Desc="Lightweight hostable IIS web core"}
        @{Name="WCF-HTTP-Activation45"; Desc="WCF HTTP activation for .NET 4.5"}
        @{Name="WCF-TCP-Activation45"; Desc="WCF TCP activation for .NET 4.5"}
        @{Name="WCF-Pipe-Activation45"; Desc="WCF named pipe activation for .NET 4.5"}
        @{Name="WCF-MSMQ-Activation45"; Desc="WCF MSMQ activation for .NET 4.5"}
        @{Name="IIS-StaticContent"; Desc="IIS static content handler"}
        @{Name="IIS-DefaultDocument"; Desc="IIS default document module"}
        @{Name="IIS-DirectoryBrowsing"; Desc="IIS directory browsing module"}
        @{Name="IIS-WebDAV"; Desc="IIS WebDAV publishing"}
        @{Name="IIS-ApplicationInit"; Desc="IIS application initialization module"}
        @{Name="IIS-ISAPIFilter"; Desc="IIS ISAPI filter support"}
        @{Name="IIS-ISAPIExtensions"; Desc="IIS ISAPI extension support"}
        @{Name="IIS-ASPNET"; Desc="IIS ASP.NET 3.5 runtime"}
        @{Name="IIS-ASP"; Desc="IIS Classic ASP engine"}
        @{Name="IIS-CGI"; Desc="IIS CGI/FastCGI handler"}
        @{Name="IIS-ServerSideIncludes"; Desc="IIS Server Side Includes module"}
        @{Name="IIS-CustomLogging"; Desc="IIS custom logging providers"}
        @{Name="IIS-BasicAuthentication"; Desc="IIS Basic Authentication module"}
        @{Name="IIS-HttpCompressionStatic"; Desc="IIS static content compression"}
        @{Name="IIS-ManagementService"; Desc="IIS Web Management Service (WMSvc)"}
        @{Name="IIS-WMICompatibility"; Desc="IIS WMI provider compatibility"}
        @{Name="IIS-LegacyScripts"; Desc="IIS legacy administration scripts"}
        @{Name="IIS-FTPServer"; Desc="IIS FTP server role"}
        @{Name="IIS-FTPSvc"; Desc="IIS FTP service"}
        @{Name="IIS-FTPExtensibility"; Desc="IIS FTP extensibility APIs"}
        @{Name="MSMQ-Container"; Desc="Microsoft Message Queuing core components"}
        @{Name="MSMQ-DCOMProxy"; Desc="MSMQ DCOM access support"}
        @{Name="MSMQ-Server"; Desc="Microsoft Message Queuing server service"}
        @{Name="MSMQ-ADIntegration"; Desc="MSMQ Active Directory integration"}
        @{Name="MSMQ-HTTP"; Desc="MSMQ HTTP transport"}
        @{Name="MSMQ-Multicast"; Desc="MSMQ multicast messaging"}
        @{Name="MSMQ-Triggers"; Desc="MSMQ trigger service"}
        @{Name="IIS-CertProvider"; Desc="IIS centralized SSL certificate support"}
        @{Name="IIS-WindowsAuthentication"; Desc="IIS Windows/NTLM authentication"}
        @{Name="IIS-DigestAuthentication"; Desc="IIS Digest authentication"}
        @{Name="IIS-ClientCertificateMappingAuthentication"; Desc="IIS one-to-one client certificate mapping"}
        @{Name="IIS-IISCertificateMappingAuthentication"; Desc="IIS many-to-one client certificate mapping"}
        @{Name="IIS-ODBCLogging"; Desc="IIS ODBC logging provider"}
        @{Name="SMB1Protocol-Deprecation"; Desc="SMB1 removal/deprecation packages"}
        @{Name="DirectoryServices-ADAM-Client"; Desc="Active Directory Lightweight Directory Services client"}
        @{Name="AppServerClient"; Desc="Application Server COM+/DTC client tools"}
        @{Name="LegacyComponents"; Desc="Legacy DirectPlay/compatibility components"}
        @{Name="DataCenterBridging"; Desc="Data Center Bridging (DCB) Ethernet features"}
        @{Name="NetFx4Extended-ASPNET45"; Desc="ASP.NET 4.5 extended components"}
        @{Name="Windows-Identity-Foundation"; Desc="Windows Identity Foundation (claims SDK)"}
        @{Name="ServicesForNFS-ClientOnly"; Desc="Services for NFS client"}
        @{Name="ClientForNFS-Infrastructure"; Desc="Client for NFS infrastructure"}
        @{Name="NFS-Administration"; Desc="NFS administration tools"}
        @{Name="HostGuardian"; Desc="Host Guardian Service support"}
        @{Name="Printing-Foundation-LPDPrintService"; Desc="Line Printer Daemon (LPD) service"}
        @{Name="Printing-Foundation-LPRPortMonitor"; Desc="Line Printer Remote (LPR) port monitor"}
        @{Name="Client-DeviceLockdown"; Desc="Windows Embedded device lockdown features"}
        @{Name="Client-EmbeddedShellLauncher"; Desc="Embedded Shell Launcher"}
        @{Name="Client-EmbeddedBootExp"; Desc="Embedded boot experience customization"}
        @{Name="Client-EmbeddedLogon"; Desc="Embedded logon experience customization"}
        @{Name="Client-KeyboardFilter"; Desc="Embedded keyboard filter (block keys)"}
        @{Name="Client-UnifiedWriteFilter"; Desc="Unified Write Filter (disk overlay)"}
        @{Name="SMB1Protocol-Client"; Desc="SMB1 client components"}
        @{Name="SMB1Protocol-Server"; Desc="SMB1 server components"}
        @{Name="Recall"; Desc="Recall holographic capture feature"}
        @{Name="HypervisorPlatform"; Desc="Hypervisor Platform APIs for third-party hypervisors"}
        @{Name="Containers-Server-For-Application-Guard"; Desc="Container services for Application Guard"}
        @{Name="HyperV-KernelInt-VirtualDevice"; Desc="Hyper-V kernel integration services"}
        @{Name="HyperV-Guest-KernelInt"; Desc="Hyper-V guest integration services"}
        @{Name="MultiPoint-Connector"; Desc="MultiPoint Services connector"}
        @{Name="MultiPoint-Connector-Services"; Desc="MultiPoint Services core"}
        @{Name="MultiPoint-Tools"; Desc="MultiPoint administration tools"}
    )
}
