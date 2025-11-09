# ==================================================================
# Windows Services Configuration
# Centralized configuration for Windows services baseline
# Used by: 6-audit-win-services.ps1, 6-win-services.ps1
# Last updated: 2025-11-09
# ==================================================================

@{
    # ================================================================
    # Services expected: Automatic (Running)
    # ================================================================
    ServicesAutomatic = @(
        @{Name="Spooler";   Desc="Print Spooler (required for PDF/virtual printers)"}
        @{Name="stisvc";    Desc="Windows Image Acquisition (scanner/camera service)"}
        @{Name="WebClient"; Desc="WebDAV Redirector (SharePoint/OneDrive drive maps)"}
        @{Name="WSearch";   Desc="Windows Search (file/email indexing)"}
        @{Name="BITS";      Desc="Background Intelligent Transfer Service (trusted downloader)"}
        @{Name="Schedule";  Desc="Task Scheduler (runs maintenance jobs)"}
        @{Name="W32Time";   Desc="Windows Time (domain/time sync)"}
        @{Name="Winmgmt";   Desc="Windows Management Instrumentation (WMI provider host)"}
        @{Name="wuauserv";  Desc="Windows Update (core servicing engine)"}
    )

    # ================================================================
    # Services expected: Manual
    # ================================================================
    ServicesManual = @(
        @{Name="msiserver"; Desc="Windows Installer (MSI package handling)"}
        @{Name="WerSvc";    Desc="Windows Error Reporting (crash upload + diagnostics)"}
    )

    # ================================================================
    # Services expected: Disabled (Stopped)
    # ================================================================
    ServicesDisabled = @(
        @{Name="RemoteAccess";    Desc="Routing and Remote Access (legacy VPN server surface)"}
        @{Name="RemoteRegistry";  Desc="Remote Registry (remote hive editing attack surface)"}
    )

    # ================================================================
    # NEW ADDITIONS - Review and categorize these services
    # Imported from ServicesList.csv (Windows services only)
    # These need to be reviewed and moved to appropriate categories above
    # ================================================================

    # Services currently set to Automatic (from CSV export)
    ServicesAutomaticNew = @(
        @{Name="AudioEndpointBuilder"; Desc="Windows Audio Endpoint Builder (initializes audio endpoints and device graph)"}
        @{Name="Audiosrv"; Desc="Windows Audio (core audio engine service)"}
        @{Name="BFE"; Desc="Base Filtering Engine (firewall/IPsec policy enforcement)"}
        @{Name="BrokerInfrastructure"; Desc="Background Tasks Infrastructure Service (modern app background scheduler)"}
        @{Name="BTAGService"; Desc="Bluetooth Audio Gateway Service (routes phone audio over Bluetooth)"}
        @{Name="bthserv"; Desc="Bluetooth Support Service (pairing and management for Bluetooth devices)"}
        @{Name="camsvc"; Desc="Capability Access Manager Service (grants or revokes app capability permissions)"}
        @{Name="cbdhsvc_12bb73"; Desc="Clipboard User Service_12bb73 (per-user cloud clipboard sync)"}
        @{Name="CDPSvc"; Desc="Connected Devices Platform Service (proximity/device graph broker)"}
        @{Name="CDPUserSvc_12bb73"; Desc="Connected Devices Platform User Service_12bb73 (per-user device graph link)"}
        @{Name="ClickToRunSvc"; Desc="Microsoft Office Click-to-Run Service (streamed Office installs and updates)"}
        @{Name="CoreMessagingRegistrar"; Desc="CoreMessaging (WinRT messaging broker registration)"}
        @{Name="CryptSvc"; Desc="Cryptographic Services (certificate management and catalog signing)"}
        @{Name="DcomLaunch"; Desc="DCOM Server Process Launcher (COM/DCOM activation host)"}
        @{Name="DeviceAssociationService"; Desc="Device Association Service (pairs peripherals and Miracast devices)"}
        @{Name="Dhcp"; Desc="DHCP Client (requests IP configuration from DHCP servers)"}
        @{Name="DiagTrack"; Desc="Connected User Experiences and Telemetry (diagnostic telemetry uploader)"}
        @{Name="DispBrokerDesktopSvc"; Desc="Display Policy Service (manages multi-display and projection policy)"}
        @{Name="Dnscache"; Desc="DNS Client (local resolver cache and dynamic registration)"}
        @{Name="DoSvc"; Desc="Delivery Optimization (peer-assisted Windows Update downloads)"}
        @{Name="DPS"; Desc="Diagnostic Policy Service (detects and troubleshoots OS issues)"}
        @{Name="DusmSvc"; Desc="Data Usage (tracks metered network usage and limits)"}
        @{Name="edgeupdate"; Desc="Microsoft Edge Update Service (edgeupdate) (keeps Edge browser patched)"}
        @{Name="EventLog"; Desc="Windows Event Log (records system/application/security logs)"}
        @{Name="EventSystem"; Desc="COM+ Event System (publishes system event notifications)"}
        @{Name="FontCache"; Desc="Windows Font Cache Service (caches glyph data for performance)"}
        @{Name="gpsvc"; Desc="Group Policy Client (applies domain and local policies)"}
        @{Name="Identity Standard Service"; Desc="Identity Standard Service (Microsoft account/AAD identity plumbing)"}
        @{Name="IKEEXT"; Desc="IKE and AuthIP IPsec Keying Modules (IPsec negotiation engine)"}
        @{Name="InventorySvc"; Desc="Inventory and Compatibility Appraisal service (Windows Update readiness scans)"}
        @{Name="iphlpsvc"; Desc="IP Helper (IPv6 transition tunnels and network telemetry)"}
        @{Name="LanmanServer"; Desc="Server (SMB file and printer sharing host)"}
        @{Name="LanmanWorkstation"; Desc="Workstation (SMB client redirector)"}
        @{Name="LSM"; Desc="Local Session Manager (creates and switches user sessions)"}
        @{Name="MapsBroker"; Desc="Downloaded Maps Manager (offline maps download agent)"}
        @{Name="MDCoreSvc"; Desc="Microsoft Defender Core Service (Defender platform orchestration)"}
        @{Name="mpssvc"; Desc="Windows Defender Firewall (stateful firewall engine)"}
        @{Name="nsi"; Desc="Network Store Interface Service (network topology notifications)"}
        @{Name="OneSyncSvc_12bb73"; Desc="Sync Host_12bb73 (per-user sync for Mail/Calendar/People data)"}
        @{Name="PcaSvc"; Desc="Program Compatibility Assistant Service (shim support for legacy apps)"}
        @{Name="Power"; Desc="Power (applies power plans and battery policy)"}
        @{Name="ProfSvc"; Desc="User Profile Service (loads/unloads user profiles)"}
        @{Name="RpcEptMapper"; Desc="RPC Endpoint Mapper (maps RPC interfaces to network ports)"}
        @{Name="RpcSs"; Desc="Remote Procedure Call (RPC) (core RPC runtime)"}
        @{Name="RtkAudioUniversalService"; Desc="Realtek Audio Universal Service (Realtek audio enhancements)"}
        @{Name="SamSs"; Desc="Security Accounts Manager (stores local account secrets)"}
        @{Name="SENS"; Desc="System Event Notification Service (broadcasts power/network changes)"}
        @{Name="ShellHWDetection"; Desc="Shell Hardware Detection (AutoPlay and media insert events)"}
        @{Name="sppsvc"; Desc="Software Protection (license activation/validation)"}
        @{Name="SQLWriter"; Desc="SQL Server VSS Writer (VSS integration for SQL Express)"}
        @{Name="StateRepository"; Desc="State Repository Service (WinRT state database host)"}
        @{Name="StorSvc"; Desc="Storage Service (storage tiering and provisioning)"}
        @{Name="SysMain"; Desc="SysMain (Superfetch/prefetch optimizer)"}
        @{Name="SystemEventsBroker"; Desc="System Events Broker (WinRT background trigger host)"}
        @{Name="TextInputManagementService"; Desc="Text Input Management Service (touch keyboard/IME coordination)"}
        @{Name="Themes"; Desc="Themes (visual styles engine)"}
        @{Name="TrkWks"; Desc="Distributed Link Tracking Client (repairs shortcuts to moved files)"}
        @{Name="TrustedInstaller"; Desc="Windows Modules Installer (servicing stack worker)"}
        @{Name="UserManager"; Desc="User Manager (manages multi-user session runtime)"}
        @{Name="UsoSvc"; Desc="Update Orchestrator Service (schedules Windows Update)"}
        @{Name="vmms"; Desc="Hyper-V Virtual Machine Management (Hyper-V VM controller)"}
        @{Name="Wcmsvc"; Desc="Windows Connection Manager (network cost/roaming decisions)"}
        @{Name="webthreatdefusersvc_12bb73"; Desc="Web Threat Defense User Service_12bb73 (per-user web filtering agent)"}
        @{Name="whesvc"; Desc="Windows Health and Optimized Experiences (device health insights)"}
        @{Name="WinDefend"; Desc="Microsoft Defender Antivirus Service (antimalware engine)"}
        @{Name="WlanSvc"; Desc="WLAN AutoConfig (Wi-Fi connection manager)"}
        @{Name="WpnService"; Desc="Windows Push Notifications System Service (toast router)"}
        @{Name="WpnUserService_12bb73"; Desc="Windows Push Notifications User Service_12bb73 (per-user notification router)"}
        @{Name="WSAIFabricSvc"; Desc="WSAIFabricSvc (Windows Subsystem for Android fabric host)"}
        @{Name="wscsvc"; Desc="Security Center (reports AV/firewall status)"}
        @{Name="WSLService"; Desc="WSL Service (manages Windows Subsystem for Linux instances)"}
    )

    # Services currently set to Manual (from CSV export)
    ServicesManualNew = @(
        @{Name="AarSvc_12bb73"; Desc="Agent Activation Runtime_12bb73 (per-user voice assistant wake-word listener)"}
        @{Name="ADPSvc"; Desc="ADPSvc (Autopilot Device Preparation provisioning agent)"}
        @{Name="ALG"; Desc="Application Layer Gateway Service (legacy firewall/NAT helper for ICS)"}
        @{Name="AppIDSvc"; Desc="Application Identity (AppLocker trust evaluation)"}
        @{Name="Appinfo"; Desc="Application Information (elevation prompt broker)"}
        @{Name="AppMgmt"; Desc="Application Management (Group Policy software install handler)"}
        @{Name="AppReadiness"; Desc="App Readiness (stages Store apps during logon)"}
        @{Name="AppXSvc"; Desc="AppX Deployment Service (AppXSVC) (installs and updates Store apps)"}
        @{Name="ApxSvc"; Desc="Windows Virtual Audio Device Proxy Service (virtual audio routing support)"}
        @{Name="AssignedAccessManagerSvc"; Desc="AssignedAccessManager Service (kiosk / assigned access policy engine)"}
        @{Name="autotimesvc"; Desc="Cellular Time (syncs time via mobile networks)"}
        @{Name="AxInstSV"; Desc="ActiveX Installer (AxInstSV) (deploys signed ActiveX controls)"}
        @{Name="BcastDVRUserService_12bb73"; Desc="GameDVR and Broadcast User Service_12bb73 (per-user game capture/streaming)"}
        @{Name="BDESVC"; Desc="BitLocker Drive Encryption Service (BitLocker management tasks)"}
        @{Name="BluetoothUserService_12bb73"; Desc="Bluetooth User Support Service_12bb73 (per-user Bluetooth stack features)"}
        @{Name="BthAvctpSvc"; Desc="AVCTP service (Bluetooth AV control transport)"}
        @{Name="CaptureService_12bb73"; Desc="CaptureService_12bb73 (per-user screen/camera capture pipeline)"}
        @{Name="CertPropSvc"; Desc="Certificate Propagation (imports smart-card certificates)"}
        @{Name="ClipSVC"; Desc="Client License Service (ClipSVC) (validates Store app licenses)"}
        @{Name="CloudBackupRestoreSvc_12bb73"; Desc="Cloud Backup and Restore Service_12bb73 (per-user settings backup)"}
        @{Name="cloudidsvc"; Desc="Microsoft Cloud Identity Service (AAD/MSA token broker)"}
        @{Name="COMSysApp"; Desc="COM+ System Application (manages COM+ catalogs)"}
        @{Name="ConsentUxUserSvc_12bb73"; Desc="ConsentUX User Service_12bb73 (per-user UWP consent UI)"}
        @{Name="CredentialEnrollmentManagerUserSvc_12bb73"; Desc="CredentialEnrollmentManagerUserSvc_12bb73 (per-user Windows Hello enrollment)"}
        @{Name="CscService"; Desc="Offline Files (caches redirected folders for offline use)"}
        @{Name="dcsvc"; Desc="Declared Configuration(DC) service (monitors policy/compliance baselines)"}
        @{Name="defragsvc"; Desc="Optimize drives (scheduled defrag/TRIM engine)"}
        @{Name="DeviceAssociationBrokerSvc_12bb73"; Desc="DeviceAssociationBroker_12bb73 (per-user pairing broker for Miracast/Bluetooth)"}
        @{Name="DeviceInstall"; Desc="Device Install Service (installs Plug and Play drivers)"}
        @{Name="DevicePickerUserSvc_12bb73"; Desc="DevicePicker_12bb73 (per-user device picker UI)"}
        @{Name="DevicesFlowUserSvc_12bb73"; Desc="DevicesFlow_12bb73 (per-user cross-device experiences host)"}
        @{Name="DevQueryBroker"; Desc="DevQuery Background Discovery Broker (finds devices for apps)"}
        @{Name="diagsvc"; Desc="Diagnostic Execution Service (runs Windows diagnostic packages)"}
        @{Name="DisplayEnhancementService"; Desc="Display Enhancement Service (adaptive color/brightness adjustments)"}
        @{Name="DmEnrollmentSvc"; Desc="Device Management Enrollment Service (handles Azure AD/MDM enrollment)"}
        @{Name="dmwappushservice"; Desc="Device Management WAP Push service (receives MDM push commands)"}
        @{Name="dot3svc"; Desc="Wired AutoConfig (802.1X authentication for Ethernet)"}
        @{Name="DsmSvc"; Desc="Device Setup Manager (USB/install coordination)"}
        @{Name="DsSvc"; Desc="Data Sharing Service (shares data between Store apps)"}
        @{Name="EapHost"; Desc="Extensible Authentication Protocol (EAP authentication for 802.1X/VPN)"}
        @{Name="edgeupdatem"; Desc="Microsoft Edge Update Service (edgeupdatem) (machine-scope updater)"}
        @{Name="EFS"; Desc="Encrypting File System (EFS) (NTFS file encryption helper)"}
        @{Name="embeddedmode"; Desc="Embedded Mode (Windows IoT/lockdown features)"}
        @{Name="EntAppSvc"; Desc="Enterprise App Management Service (MSIX enterprise provisioning)"}
        @{Name="fdPHost"; Desc="Function Discovery Provider Host (discovers network devices)"}
        @{Name="FDResPub"; Desc="Function Discovery Resource Publication (publishes local printers/shares)"}
        @{Name="fhsvc"; Desc="File History Service (continuous backup of libraries)"}
        @{Name="FileSyncHelper"; Desc="FileSyncHelper (OneDrive/consumer sync helper)"}
        @{Name="FontCache3.0.0.0"; Desc="WPF Font Cache 3.0.0.0 (caches fonts for WPF apps)"}
        @{Name="FrameServer"; Desc="Windows Camera Frame Server (shares camera streams)"}
        @{Name="FrameServerMonitor"; Desc="Windows Camera Frame Server Monitor (watches FrameServer health)"}
        @{Name="GameInputSvc"; Desc="GameInput Service (low-latency controller input pipeline)"}
        @{Name="GraphicsPerfSvc"; Desc="GraphicsPerfSvc (collects GPU telemetry for optimizations)"}
        @{Name="HgClientService"; Desc="Host Guardian Client Service (shielded VM attestation client)"}
        @{Name="hidserv"; Desc="Human Interface Device Service (hotkeys and HID buttons)"}
        @{Name="hns"; Desc="Host Network Service (container/WSL networking)"}
        @{Name="hpatchmon"; Desc="Hotpatch Monitoring Service (tracks hotpatch applicability)"}
        @{Name="HvHost"; Desc="HV Host Service (Hyper-V host runtime support)"}
        @{Name="icssvc"; Desc="Windows Mobile Hotspot Service (Internet sharing over Wi-Fi)"}
        @{Name="InstallService"; Desc="Microsoft Store Install Service (installs MSIX/Store content)"}
        @{Name="IpxlatCfgSvc"; Desc="IP Translation Configuration Service (configures 464XLAT/NAT64 for cellular)"}
        @{Name="KeyIso"; Desc="CNG Key Isolation (isolated cryptographic key process)"}
        @{Name="KtmRm"; Desc="KtmRm for Distributed Transaction Coordinator (kernel transaction manager resource)"}
        @{Name="lfsvc"; Desc="Geolocation Service (GPS/Wi-Fi location provider)"}
        @{Name="LicenseManager"; Desc="Windows License Manager Service (Store entitlement enforcement)"}
        @{Name="lltdsvc"; Desc="Link-Layer Topology Discovery Mapper (network map discovery client)"}
        @{Name="lmhosts"; Desc="TCP/IP NetBIOS Helper (NetBIOS name resolution support)"}
        @{Name="LocalKdc"; Desc="Kerberos Local Key Distribution Center (local realm for credentials)"}
        @{Name="LxpSvc"; Desc="Language Experience Service (downloads language resources)"}
        @{Name="McmSvc"; Desc="Mobile Connectivity Management Service (manages eSIM and data plans)"}
        @{Name="McpManagementService"; Desc="McpManagementService (modern connected standby policy manager)"}
        @{Name="MessagingService_12bb73"; Desc="MessagingService_12bb73 (per-user SMS / Phone Link integration)"}
        @{Name="MicrosoftEdgeElevationService"; Desc="Microsoft Edge Elevation Service (elevates updater when needed)"}
        @{Name="midisrv"; Desc="Windows MIDI Service (Bluetooth/USB MIDI routing)"}
        @{Name="MSDTC"; Desc="Distributed Transaction Coordinator (coordinates cross-resource transactions)"}
        @{Name="MSiSCSI"; Desc="Microsoft iSCSI Initiator Service (connects to iSCSI storage)"}
        @{Name="NaturalAuthentication"; Desc="Natural Authentication (companion/biometric gesture detection)"}
        @{Name="NcaSvc"; Desc="Network Connectivity Assistant (corporate network detection)"}
        @{Name="NcbService"; Desc="Network Connection Broker (provides network triggers to UWP apps)"}
        @{Name="NcdAutoSetup"; Desc="Network Connected Devices Auto-Setup (auto-installs network printers/devices)"}
        @{Name="Netlogon"; Desc="Netlogon (domain logon secure channel)"}
        @{Name="Netman"; Desc="Network Connections (manages adapters and connection profiles)"}
        @{Name="netprofm"; Desc="Network List Service (identifies network profiles)"}
        @{Name="NetSetupSvc"; Desc="Network Setup Service (provisions new network interfaces)"}
        @{Name="NgcCtnrSvc"; Desc="Microsoft Passport Container (Windows Hello key storage)"}
        @{Name="NgcSvc"; Desc="Microsoft Passport (Windows Hello authentication broker)"}
        @{Name="NlaSvc"; Desc="Network Location Awareness (drives firewall/public-private state)"}
        @{Name="NPSMSvc_12bb73"; Desc="Now Playing Session Manager Service_12bb73 (per-user media session sharing)"}
        @{Name="nvagent"; Desc="Network Virtualization Service (Hyper-V network virtualization agent)"}
        @{Name="OneDrive Updater Service"; Desc="OneDrive Updater Service (keeps OneDrive client updated)"}
        @{Name="P9RdrService_12bb73"; Desc="P9RdrService_12bb73 (per-user pen/inking renderer)"}
        @{Name="PeerDistSvc"; Desc="BranchCache (peer caching for content)"}
        @{Name="PenService_12bb73"; Desc="PenService_12bb73 (per-user pen and Windows Ink features)"}
        @{Name="perceptionsimulation"; Desc="Windows Perception Simulation Service (mixed reality simulation)"}
        @{Name="PerfHost"; Desc="Performance Counter DLL Host (out-of-process perf counters)"}
        @{Name="PhoneSvc"; Desc="Phone Service (phone call/continuity integration)"}
        @{Name="PimIndexMaintenanceSvc_12bb73"; Desc="Contact Data_12bb73 (per-user contact indexer)"}
        @{Name="pla"; Desc="Performance Logs & Alerts (collects perf counter logs)"}
        @{Name="PlugPlay"; Desc="Plug and Play (detects hardware changes)"}
        @{Name="PolicyAgent"; Desc="IPsec Policy Agent (applies IPsec/L2TP policies)"}
        @{Name="PrintDeviceConfigurationService"; Desc="Print Device Configuration Service (printer-specific configuration tasks)"}
        @{Name="PrintNotify"; Desc="Printer Extensions and Notifications (modern print UX)"}
        @{Name="PrintScanBrokerService"; Desc="PrintScanBrokerService (inbox print/scan app broker)"}
        @{Name="PrintWorkflowUserSvc_12bb73"; Desc="PrintWorkflow_12bb73 (per-user modern print workflow host)"}
        @{Name="PushToInstall"; Desc="Windows PushToInstall Service (remote Store install handler)"}
        @{Name="QWAVE"; Desc="Quality Windows Audio Video Experience (QoS for audio/video streams)"}
        @{Name="RasAuto"; Desc="Remote Access Auto Connection Manager (launches VPN/dialup on demand)"}
        @{Name="RasMan"; Desc="Remote Access Connection Manager (VPN/dialup core)"}
        @{Name="refsdedupsvc"; Desc="ReFS Dedup Service (deduplication for ReFS volumes)"}
        @{Name="RetailDemo"; Desc="Retail Demo Service (controls demo experience mode)"}
        @{Name="RmSvc"; Desc="Radio Management Service (airplane mode for radios)"}
        @{Name="RpcLocator"; Desc="Remote Procedure Call (RPC) Locator (legacy RPC directory)"}
        @{Name="SCardSvr"; Desc="Smart Card (access to smart card devices)"}
        @{Name="ScDeviceEnum"; Desc="Smart Card Device Enumeration Service (detects inserted cards)"}
        @{Name="SCPolicySvc"; Desc="Smart Card Removal Policy (locks PC when card removed)"}
        @{Name="SDRSVC"; Desc="Windows Backup (system restore/backup scheduling)"}
        @{Name="seclogon"; Desc="Secondary Logon (Run as different user support)"}
        @{Name="SecurityHealthService"; Desc="Windows Security Service (feeds Windows Security app)"}
        @{Name="SEMgrSvc"; Desc="Payments and NFC/SE Manager (Wallet/NFC secure element)"}
        @{Name="Sense"; Desc="Windows Defender Advanced Threat Protection Service (Defender for Endpoint agent)"}
        @{Name="SensorDataService"; Desc="Sensor Data Service (aggregates sensor readings)"}
        @{Name="SensorService"; Desc="Sensor Service (exposes sensors to apps)"}
        @{Name="SensrSvc"; Desc="Sensor Monitoring Service (auto-rotation/light adjustments)"}
        @{Name="SessionEnv"; Desc="Remote Desktop Configuration (prepares RDP sessions)"}
        @{Name="SharedAccess"; Desc="Internet Connection Sharing (ICS) (NAT/router service)"}
        @{Name="smphost"; Desc="Microsoft Storage Spaces SMP (Storage Spaces management)"}
        @{Name="SmsRouter"; Desc="Microsoft Windows SMS Router Service (routes SMS for Phone Link)"}
        @{Name="SNMPTrap"; Desc="SNMP Trap (listens for SNMP traps)"}
        @{Name="SSDPSRV"; Desc="SSDP Discovery (discovers UPnP/Plug and Play devices)"}
        @{Name="sshd"; Desc="OpenSSH SSH Server (Windows SSH daemon)"}
        @{Name="SstpSvc"; Desc="Secure Socket Tunneling Protocol Service (SSTP VPN listener)"}
        @{Name="svsvc"; Desc="Spot Verifier (verifies file data for NTFS snapshots)"}
        @{Name="swprv"; Desc="Microsoft Software Shadow Copy Provider (VSS provider)"}
        @{Name="TapiSrv"; Desc="Telephony (TAPI support for legacy apps)"}
        @{Name="TermService"; Desc="Remote Desktop Services (RDP host service)"}
        @{Name="TieringEngineService"; Desc="Storage Tiers Management (Storage Spaces tiering)"}
        @{Name="TimeBrokerSvc"; Desc="Time Broker (WinRT background task scheduler)"}
        @{Name="TokenBroker"; Desc="Web Account Manager (MSA/AAD token broker)"}
        @{Name="TroubleshootingSvc"; Desc="Recommended Troubleshooting Service (automatic fix suggestions)"}
        @{Name="UdkUserSvc_12bb73"; Desc="Udk User Service_12bb73 (per-user UWP shell background task)"}
        @{Name="UmRdpService"; Desc="Remote Desktop Services UserMode Port Redirector (USB/printer redirection)"}
        @{Name="UnistoreSvc_12bb73"; Desc="User Data Storage_12bb73 (per-user structured storage for apps)"}
        @{Name="upnphost"; Desc="UPnP Device Host (hosts UPnP devices)"}
        @{Name="UserDataSvc_12bb73"; Desc="User Data Access_12bb73 (per-user contact/calendar data store)"}
        @{Name="VaultSvc"; Desc="Credential Manager (stores saved credentials)"}
        @{Name="vds"; Desc="Virtual Disk (legacy disk management service)"}
        @{Name="vmcompute"; Desc="Hyper-V Host Compute Service (container/WSL compute runtime)"}
        @{Name="vmicguestinterface"; Desc="Hyper-V Guest Service Interface (guest communications channel)"}
        @{Name="vmicheartbeat"; Desc="Hyper-V Heartbeat Service (guest heartbeat channel)"}
        @{Name="vmickvpexchange"; Desc="Hyper-V Data Exchange Service (KVP data channel)"}
        @{Name="vmicrdv"; Desc="Hyper-V Remote Desktop Virtualization Service (enhanced session support)"}
        @{Name="vmicshutdown"; Desc="Hyper-V Guest Shutdown Service (coordinated shutdowns)"}
        @{Name="vmictimesync"; Desc="Hyper-V Time Synchronization Service (syncs guest clock)"}
        @{Name="vmicvmsession"; Desc="Hyper-V PowerShell Direct Service (PowerShell Direct channel)"}
        @{Name="vmicvss"; Desc="Hyper-V Volume Shadow Copy Requestor (guest VSS integration)"}
        @{Name="VSS"; Desc="Volume Shadow Copy (snapshot coordinator)"}
        @{Name="WaaSMedicSvc"; Desc="WaaSMedicSvc (repairs Windows Update components)"}
        @{Name="WalletService"; Desc="WalletService (Microsoft Wallet backend)"}
        @{Name="WarpJITSvc"; Desc="Warp JIT Service (software rasterizer acceleration)"}
        @{Name="wbengine"; Desc="Block Level Backup Engine Service (wbadmin backups)"}
        @{Name="WbioSrvc"; Desc="Windows Biometric Service (biometric sensor framework)"}
        @{Name="wcncsvc"; Desc="Windows Connect Now - Config Registrar (Wi-Fi Protected Setup)"}
        @{Name="WdiServiceHost"; Desc="Diagnostic Service Host (runs shared diagnostic hosts)"}
        @{Name="WdiSystemHost"; Desc="Diagnostic System Host (runs system diagnostics)"}
        @{Name="WdNisSvc"; Desc="Microsoft Defender Antivirus Network Inspection Service (IDS engine)"}
        @{Name="webthreatdefsvc"; Desc="Web Threat Defense Service (enterprise web protection agent)"}
        @{Name="Wecsvc"; Desc="Windows Event Collector (collects forwarded events)"}
        @{Name="WEPHOSTSVC"; Desc="Windows Encryption Provider Host Service (hardware encryption host)"}
        @{Name="wercplsupport"; Desc="Problem Reports Control Panel Support (WER UI integration)"}
        @{Name="WFDSConMgrSvc"; Desc="Wi-Fi Direct Services Connection Manager Service (Wi-Fi Direct sessions)"}
        @{Name="WiaRpc"; Desc="Still Image Acquisition Events (WIA event broker)"}
        @{Name="WinHttpAutoProxySvc"; Desc="WinHTTP Web Proxy Auto-Discovery Service (WPAD client)"}
        @{Name="WinRM"; Desc="Windows Remote Management (WS-Management remoting)"}
        @{Name="wisvc"; Desc="Windows Insider Service (manages Insider build flighting)"}
        @{Name="wlidsvc"; Desc="Microsoft Account Sign-in Assistant (MSA authentication helper)"}
        @{Name="wlpasvc"; Desc="Local Profile Assistant Service (AAD/MSA roaming profile support)"}
        @{Name="WManSvc"; Desc="Windows Management Service (device manageability / DFCI)"}
        @{Name="wmiApSrv"; Desc="WMI Performance Adapter (publishes perf counters to WMI)"}
        @{Name="workfolderssvc"; Desc="Work Folders (syncs on-prem file shares)"}
        @{Name="WpcMonSvc"; Desc="Parental Controls (enforces family safety)"}
        @{Name="WPDBusEnum"; Desc="Portable Device Enumerator Service (enumerates MTP/PTP devices)"}
        @{Name="wuqisvc"; Desc="Microsoft Usage and Quality Insights (telemetry for usage insights)"}
        @{Name="WwanSvc"; Desc="WWAN AutoConfig (cellular modem connections)"}
        @{Name="ZTHELPER"; Desc="ZTDNS Helper service (Zero Touch deployment DNS helper)"}
    )

    # Services currently set to Disabled (from CSV export)
    ServicesDisabledNew = @(
        @{Name="AppVClient"; Desc="Microsoft App-V Client (application virtualization runtime)"}
        @{Name="DialogBlockingService"; Desc="DialogBlockingService (blocks unexpected dialogs for kiosk/lockdown setups)"}
        @{Name="MsKeyboardFilter"; Desc="Microsoft Keyboard Filter (embedded device key blocking)"}
        @{Name="NetTcpPortSharing"; Desc="Net.Tcp Port Sharing Service (WCF shared port listener)"}
        @{Name="shpamsvc"; Desc="Shared PC Account Manager (cleans shared device accounts)"}
        @{Name="ssh-agent"; Desc="OpenSSH Authentication Agent (stores SSH keys in memory)"}
        @{Name="tzautoupdate"; Desc="Auto Time Zone Updater (adjusts time zone based on location)"}
        @{Name="UevAgentService"; Desc="User Experience Virtualization Service (UE-V settings roam agent)"}
    )

    # ================================================================
    # THIRD-PARTY / VENDOR SERVICES - For reference only
    # These are NOT managed by the scripts - listed for documentation
    # Filtered during Windows-only import
    # Source: ServicesList.csv export
    # ================================================================

    # Third-party services set to Automatic
    ThirdPartyAutomatic = @(
        # Adobe
        @{Name="AdobeARMservice"; Desc="Adobe Acrobat auto-update service (keeps Reader/Acrobat patched)"}

        # AnyDesk
        @{Name="AnyDesk"; Desc="AnyDesk remote desktop host service (allows inbound sessions)"}

        # ASUS
        @{Name="AsusCertService"; Desc="ASUS certificate provisioning service (trusts OEM utilities)"}
        @{Name="AsusUpdateCheck"; Desc="ASUS Live Update checker (polls for BIOS/driver updates)"}

        # Dell
        @{Name="DellClientManagementService"; Desc="Dell Command | Update management service (applies OEM updates)"}
        @{Name="DellTechHub"; Desc="Dell TechHub support/telemetry helper"}

        # Google Chrome
        @{Name="chromoting"; Desc="Chrome Remote Desktop host service (Google remote access)"}
        @{Name="GoogleUpdaterInternalService143.0.7482.0"; Desc="Google Update internal worker (installs Google apps)"}
        @{Name="GoogleUpdaterService143.0.7482.0"; Desc="Google Update service wrapper (schedules Chrome/Drive updates)"}

        # Dropbox
        @{Name="DbxSvc"; Desc="Dropbox sync engine service (shell overlays + context menus)"}
        @{Name="DropboxUpdaterInternalService123.0.6299.129"; Desc="Dropbox background updater (internal worker)"}
        @{Name="DropboxUpdaterService123.0.6299.129"; Desc="Dropbox updater orchestration service"}

        # Microsoft Office
        @{Name="ClickToRunSvc"; Desc="Microsoft 365 Click-to-Run streaming installer/updater"}

        # Microsoft Edge
        @{Name="edgeupdate"; Desc="Microsoft Edge auto-update service (system scope)"}

        # Everything Search
        @{Name="Everything"; Desc="Everything file search indexer (voidtools)"}

        # Intel
        @{Name="dptftcs"; Desc="Intel Dynamic Tuning Technology telemetry service"}
        @{Name="igccservice"; Desc="Intel Graphics Command Center background service"}
        @{Name="Intel(R) Platform License Manager Service"; Desc="Intel Platform License Manager (licenses DTT features)"}
        @{Name="IntelDisplayUMService"; Desc="Intel Graphics Display Service (UMD event notifications)"}
        @{Name="IntelGraphicsSoftwareService"; Desc="Intel Graphics Software companion service"}
        @{Name="ipfsvc"; Desc="Intel Innovation Platform Framework service (sensors/power features)"}
        @{Name="LMS"; Desc="Intel Management & Security Application Local Management Service"}
        @{Name="RstMwService"; Desc="Intel Rapid Storage middleware service"}
        @{Name="WMIRegistrationService"; Desc="Intel Management Engine WMI provider registration"}

        # Logitech
        @{Name="LGHUBUpdaterService"; Desc="Logitech G HUB updater (peripheral firmware/software)"}
        @{Name="logi_lamparray_service"; Desc="Logitech Lightsync LampArray service (RGB lighting control)"}

        # Identity Standard Service (third-party identity provider)
        @{Name="Identity Standard Service"; Desc="Identity Standard Service (third-party identity provider agent)"}

        # Malwarebytes
        @{Name="MBAMService"; Desc="Malwarebytes Anti-Malware core service"}

        # NVIDIA
        @{Name="NvContainerLocalSystem"; Desc="NVIDIA LocalSystem Container (GeForce Experience tasks)"}
        @{Name="NVDisplay.ContainerLocalSystem"; Desc="NVIDIA Display Container LS (tray + telemetry host)"}
        @{Name="NVWMI"; Desc="NVIDIA WMI provider service (GPU telemetry)"}

        # Realtek
        @{Name="RtkAudioUniversalService"; Desc="Realtek Audio Universal Service (UAD APO/effects)"}

        # SQL Server
        @{Name="SQLWriter"; Desc="SQL Server VSS Writer (coordinates SQL backups)"}

        # WSAIFabricSvc (Windows Subsystem for Android - might be third-party)
        @{Name="WSAIFabricSvc"; Desc="Windows Subsystem for Android fabric service"}
    )

    # Third-party services set to Manual
    ThirdPartyManual = @(
        # Docker
        @{Name="com.docker.service"; Desc="Docker Desktop backend service (starts the Linux VM/container runtime)"}

        # Dropbox
        @{Name="DropboxElevationService"; Desc="Dropbox elevation helper (runs installs with admin rights)"}

        # Epic Games
        @{Name="EasyAntiCheat_EOS"; Desc="Easy Anti-Cheat EOS service (anti-cheat monitor)"}
        @{Name="EpicGamesUpdater"; Desc="Epic Games Launcher updater service"}
        @{Name="EpicOnlineServices"; Desc="Epic Online Services background platform service"}

        # Microsoft Edge
        @{Name="edgeupdatem"; Desc="Microsoft Edge Update Service (per-user on-demand)"}
        @{Name="MicrosoftEdgeElevationService"; Desc="Microsoft Edge elevation helper (UAC broker)"}

        # Microsoft Office
        @{Name="FileSyncHelper"; Desc="Microsoft 365 FileSyncHelper (OneDrive/SharePoint integration)"}

        # NVIDIA
        @{Name="FvSvc"; Desc="NVIDIA FrameView SDK service (captures performance metrics)"}

        # Google Chrome
        @{Name="GoogleChromeElevationService"; Desc="Google Chrome elevation helper (runs updates with admin rights)"}

        # Malwarebytes
        @{Name="MBVpnTunnelService"; Desc="Malwarebytes Privacy VPN tunnel service"}

        # OneDrive
        @{Name="OneDrive Updater Service"; Desc="OneDrive updater service (consumer sync client)"}

        # ProtonVPN
        @{Name="ProtonVPN Service"; Desc="ProtonVPN service (establishes VPN tunnels)"}

        # Steam
        @{Name="Steam Client Service"; Desc="Steam Client Service (installs games/updates with elevation)"}

        # Visual Studio
        @{Name="VSInstallerElevationService"; Desc="Visual Studio Installer elevation service"}
        @{Name="VSStandardCollectorService150"; Desc="Visual Studio Standard Collector Service 150 (diagnostics/telemetry)"}
    )

    # Third-party services set to Disabled
    ThirdPartyDisabled = @(
        # Note: No third-party services currently set to Disabled in the export
    )
}
