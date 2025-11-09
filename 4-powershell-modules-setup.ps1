# PowerShell Modules Installation Script
# STEP 4 OF 5: Run this file after completing steps 1-3
# run as Administrator
# .\4-powershell-modules-setup.ps1
# Last updated: 2025-11-08

############################################
# Helper functions
############################################

function Write-Result {
    param(
        [string]$Name,
        [bool]$Success,
        [string]$Message
    )

    if ($Success) {
        Write-Host "${Name}: $Message" -ForegroundColor Green
    }
    else {
        Write-Host "${Name}: $Message" -ForegroundColor Red
    }
}

function Set-TlsProtocol {
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        Write-Result "TLS" $true "TLS 1.2 enabled (appended to existing protocols)"
    }
    catch {
        Write-Result "TLS" $false "Failed to enable TLS 1.2: $($_.Exception.Message)"
    }
}

function Initialize-PowerShellGet {
    Write-Host "`n=== Checking PowerShellGet ===" -ForegroundColor Cyan
    try {
        Import-Module PowerShellGet -ErrorAction Stop
        Write-Result "PowerShellGet" $true "Imported existing module"
    }
    catch {
        Write-Result "PowerShellGet" $false "Failed to import existing module: $($_.Exception.Message)"
        Write-Host "Attempting Install-Module PowerShellGet..." -ForegroundColor Yellow
        try {
            Install-Module PowerShellGet -Scope CurrentUser -Force -ErrorAction Stop
            Import-Module PowerShellGet -ErrorAction Stop
            Write-Result "PowerShellGet" $true "Installed and imported PowerShellGet"
        }
        catch {
            Write-Result "PowerShellGet" $false "Install-Module PowerShellGet failed: $($_.Exception.Message)"
        }
    }

    # Try to update if possible (non-fatal if it fails)
    try {
        # Check if running as admin
        $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        # Get module installation path to determine scope
        # Sort by version descending to get the newest installed version
        $moduleInfo = Get-Module -ListAvailable -Name PowerShellGet | Sort-Object Version -Descending | Select-Object -First 1
        if ($moduleInfo) {
            $modulePath = $moduleInfo.ModuleBase
            $isSystemScope = $modulePath -like "*Program Files*"

            if ($isSystemScope -and -not $isAdmin) {
                Write-Host "  [INFO] PowerShellGet is system-scoped and requires admin to update. Skipping update." -ForegroundColor Gray
            }
            elseif (-not $isAdmin) {
                # User scope update
                Update-Module PowerShellGet -Scope CurrentUser -ErrorAction Stop
                Write-Result "PowerShellGet" $true "Updated (CurrentUser scope)"
            }
            else {
                # Admin can update any scope
                Update-Module PowerShellGet -ErrorAction Stop
                Write-Result "PowerShellGet" $true "Updated successfully"
            }
        }
        else {
            Write-Host "  [INFO] PowerShellGet module not found for update check" -ForegroundColor Gray
        }
    }
    catch {
        Write-Result "PowerShellGet" $false "Update failed: $($_.Exception.Message)"
    }
}

function Initialize-NuGetProvider {
    Write-Host "`n=== Checking NuGet Package Provider ===" -ForegroundColor Cyan

    $minVersion = [version]'2.8.5.201'
    $provider   = Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue

    if ($provider) {
        $currentVersion = [version]$provider.Version
        Write-Host "NuGet provider found: $currentVersion" -ForegroundColor Yellow

        if ($currentVersion -ge $minVersion) {
            Write-Result "NuGet" $true "Existing provider meets minimum version ($minVersion)"
            try {
                Import-PackageProvider -Name NuGet -Force -ErrorAction Stop | Out-Null
                Write-Result "NuGet" $true "Imported NuGet provider"
            }
            catch {
                Write-Result "NuGet" $false "Failed to import provider: $($_.Exception.Message)"
            }
        }
        else {
            Write-Result "NuGet" $false "Provider is older than required ($currentVersion < $minVersion), attempting update..."
            try {
                Install-PackageProvider -Name NuGet -MinimumVersion $minVersion -Force -ErrorAction Stop | Out-Null
                Import-PackageProvider -Name NuGet -Force -ErrorAction Stop | Out-Null
                Write-Result "NuGet" $true "Updated & imported provider"
            }
            catch {
                Write-Result "NuGet" $false "Failed to install/update provider: $($_.Exception.Message)"
            }
        }
    }
    else {
        Write-Host "NuGet provider not found, attempting install..." -ForegroundColor Yellow
        try {
            Install-PackageProvider -Name NuGet -MinimumVersion $minVersion -Force -ErrorAction Stop | Out-Null
            Import-PackageProvider -Name NuGet -Force -ErrorAction Stop | Out-Null
            Write-Result "NuGet" $true "Installed & imported provider"
        }
        catch {
            Write-Result "NuGet" $false "Failed to install NuGet provider: $($_.Exception.Message)"
        }
    }
}

function Install-ModuleSafe {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string]$Scope = "CurrentUser",
        [switch]$SkipPublisherCheck
    )

    Write-Host "Installing module: $Name" -ForegroundColor Cyan
    try {
        $params = @{
            Name = $Name
            Scope = $Scope
            Force = $true
            AllowClobber = $true
            ErrorAction = 'Stop'
        }
        if ($SkipPublisherCheck) {
            $params['SkipPublisherCheck'] = $true
        }
        Install-Module @params
        Write-Result "Module $Name" $true "Installed successfully"
    }
    catch {
        Write-Result "Module $Name" $false "Install-Module failed: $($_.Exception.Message)"
    }
}

############################################
# Start of script logic
############################################

Write-Host "=== STEP 4: Core PowerShell setup ===`n" -ForegroundColor Magenta

# Optional: show if we're admin or not
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$runningAsAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($runningAsAdmin) {
    Write-Host "Running as: Administrator" -ForegroundColor Yellow
} else {
    Write-Host "Running as: Standard user (some actions may prompt/fail if admin rights are required)" -ForegroundColor Yellow
}

# Show existing providers (just informational)
Write-Host "`nExisting package providers:" -ForegroundColor Cyan
Get-PackageProvider | Format-Table -AutoSize

# 1) TLS
Set-TlsProtocol

# 2) PowerShellGet
Initialize-PowerShellGet

# 3) NuGet provider
Initialize-NuGetProvider

# 4) Execution Policy for current user
Write-Host "`n=== Execution Policy ===" -ForegroundColor Cyan
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
    Write-Result "ExecutionPolicy" $true "Set to RemoteSigned for CurrentUser"
}
catch {
    Write-Result "ExecutionPolicy" $false "Failed to set policy: $($_.Exception.Message)"
}

# 5) Ensure PSGallery is trusted
Write-Host "`n=== PSRepository (PSGallery) ===" -ForegroundColor Cyan
try {
    $repo = Get-PSRepository -Name PSGallery -ErrorAction Stop
    if ($repo.InstallationPolicy -ne 'Trusted') {
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        Write-Result "PSGallery" $true "Set InstallationPolicy=Trusted"
    }
    else {
        Write-Result "PSGallery" $true "Already trusted"
    }
}
catch {
    Write-Result "PSGallery" $false "Unable to get/set PSGallery: $($_.Exception.Message)"
}

############################################
# CORE MODULES
############################################

Write-Host "`n=== Installing core modules ===" -ForegroundColor Magenta

$coreModules = @(
    'ImportExcel',
    'dbatools',
    'PSWindowsUpdate',
    'BurntToast',
    'PSWriteHTML',
    'Pester',
    'posh-git',
    'SqlServer'
)

foreach ($m in $coreModules) {
    if ($m -eq 'Pester') {
        Install-ModuleSafe -Name $m -Scope CurrentUser -SkipPublisherCheck
    }
    else {
        Install-ModuleSafe -Name $m -Scope CurrentUser
    }
}

############################################
# OPTIONAL MODULES (uncomment if needed)
############################################
# Install-ModuleSafe -Name 'Az'              -Scope CurrentUser    # Azure
# Install-ModuleSafe -Name 'Microsoft.Graph' -Scope CurrentUser    # Microsoft 365 / Graph
# Install-ModuleSafe -Name 'PSSlack'         -Scope CurrentUser    # Slack integration
# Install-ModuleSafe -Name 'PowerShellAI'    -Scope CurrentUser    # OpenAI from PowerShell

############################################
# VERIFY INSTALLATION
############################################

Write-Host "`n=== Installed module versions ===" -ForegroundColor Cyan

$coreModules | ForEach-Object {
    $mod = Get-Module -ListAvailable -Name $_ | Sort-Object Version -Descending | Select-Object -First 1
    if ($mod) {
        "{0,-18} {1}" -f $_, $mod.Version
    }
    else {
        "{0,-18} {1}" -f $_, 'not found'
    }
}

############################################
# PYTHON PIP UPGRADE (Step 5 preparation)
############################################

Write-Host "`n=== Upgrading pip ===" -ForegroundColor Cyan
try {
    # Check for Python in multiple common forms
    $pythonCmd = $null

    # Try py launcher with Python 3
    if (Get-Command py -ErrorAction SilentlyContinue) {
        $pythonCmd = 'py', '-3'
        Write-Host "Found Python via 'py' launcher" -ForegroundColor Gray
    }
    # Try python3
    elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
        $pythonCmd = 'python3'
        Write-Host "Found Python via 'python3' command" -ForegroundColor Gray
    }
    # Try python
    elseif (Get-Command python -ErrorAction SilentlyContinue) {
        $pythonCmd = 'python'
        Write-Host "Found Python via 'python' command" -ForegroundColor Gray
    }

    if ($pythonCmd) {
        # Handle both array (e.g., 'py', '-3') and string (e.g., 'python') cases
        if ($pythonCmd -is [array]) {
            $pythonExe = $pythonCmd[0]
            $pythonArgs = $pythonCmd[1..($pythonCmd.Length-1)]
            & $pythonExe @pythonArgs -m pip install --upgrade pip
        } else {
            & $pythonCmd -m pip install --upgrade pip
        }
        # Format command display properly for both strings and arrays
        $pythonCmdDisplay = if ($pythonCmd -is [array]) { $pythonCmd -join ' ' } else { $pythonCmd }
        Write-Result "pip" $true "Upgraded to latest version using $pythonCmdDisplay"
    }
    else {
        Write-Result "pip" $false "Python not found - install via step 2 (2-winget-development.ps1)"
    }
}
catch {
    Write-Result "pip" $false "Upgrade failed: $($_.Exception.Message)"
}

Write-Host "`n=== Setup complete! ===" -ForegroundColor Green
Write-Host "PowerShell modules installed and pip upgraded." -ForegroundColor Cyan
Write-Host "Next: Run step 5 (pip install -r 5-python-requirements.txt)" -ForegroundColor Cyan
