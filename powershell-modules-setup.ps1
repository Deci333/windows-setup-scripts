# PowerShell Modules Installation Script
# Run in PowerShell (run as regular user, NOT admin)
# Last updated: 2025-11-07

# === PRE-REQUISITES ===
# Update PowerShellGet & NuGet first
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Update-Module PowerShellGet -ErrorAction SilentlyContinue

# Set execution policy for current user
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Make sure PSGallery is trusted
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# === CORE MODULES ===
Install-Module ImportExcel -Scope CurrentUser -Force -AllowClobber
Install-Module dbatools -Scope CurrentUser -Force -AllowClobber
Install-Module PSWindowsUpdate -Scope CurrentUser -Force -AllowClobber
Install-Module BurntToast -Scope CurrentUser -Force -AllowClobber
Install-Module PSWriteHTML -Scope CurrentUser -Force -AllowClobber
Install-Module Pester -Scope CurrentUser -Force -AllowClobber
Install-Module posh-git -Scope CurrentUser -Force -AllowClobber
Install-Module SqlServer -Scope CurrentUser -Force -AllowClobber

# === OPTIONAL MODULES (uncomment if needed) ===
# Install-Module Az -Scope CurrentUser -Force -AllowClobber            # Azure
# Install-Module Microsoft.Graph -Scope CurrentUser -Force -AllowClobber # Microsoft 365 / Graph
# Install-Module PSSlack -Scope CurrentUser -Force -AllowClobber      # Slack integration
# Install-Module PowerShellAI -Scope CurrentUser -Force -AllowClobber # OpenAI from PowerShell

# === VERIFY INSTALLATION ===
Write-Host "`nInstalled module versions:" -ForegroundColor Cyan
'ImportExcel','dbatools','PSWindowsUpdate','BurntToast','PSWriteHTML','Pester','posh-git','SqlServer' |
  ForEach-Object {
    $m = Get-Module -ListAvailable $_ | Sort-Object Version -Descending | Select-Object -First 1
    "{0,-18} {1}" -f $_, ($m?.Version ?? 'not installed')
  }

Write-Host "`nSetup complete!" -ForegroundColor Green
