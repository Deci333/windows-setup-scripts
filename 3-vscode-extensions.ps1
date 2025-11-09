# ==================================================================
# VS Code Extensions Interactive Installation
# Checks if extensions are installed and prompts for installation
# STEP 3 OF 5: Run this file THIRD (after 1-windows-system-config.ps1 and 2-winget-development.ps1)
# Run in PowerShell (admin NOT required)
# .\3-vscode-extensions.ps1
# Last updated: 2025-11-08
# ==================================================================

# === PREREQUISITES ===
# 1. VS Code must be installed first
#    Install via: winget install -e --id Microsoft.VisualStudioCode
#    Or run step 2 (2-winget-development.ps1) which includes VS Code
# 2. You may need to close and reopen your terminal after installing VS Code
#    to ensure the 'code' command is available in your PATH
# 3. This script does NOT require administrator privileges

function Install-VSCodeExtensionInteractive {
    param(
        [string]$Id,
        [string]$Description = "",
        [bool]$Required = $false,
        [System.Collections.Generic.HashSet[string]]$InstalledExtensions
    )

    $desc = if ($Description) { " - $Description" } else { "" }
    $reqLabel = if ($Required) { "[REQUIRED]" } else { "[OPTIONAL]" }

    try {
        # Check if already installed (case-insensitive)
        $isInstalled = $InstalledExtensions.Contains($Id.ToLower())

        if ($isInstalled) {
            Write-Host "[OK] $Id is already installed$desc" -ForegroundColor Green
            return
        }

        # Extension not installed - prompt user
        Write-Host "`n$reqLabel $Id$desc" -ForegroundColor $(if ($Required) { "Yellow" } else { "Cyan" })
        Write-Host "  Status: Not installed" -ForegroundColor Cyan

        $response = Read-Host "  Install this extension? (Y/n)"

        if ($response -eq '' -or $response -match '^[Yy]') {
            try {
                Write-Host "  Installing $Id..." -ForegroundColor Cyan
                $output = code --install-extension $Id 2>&1

                if ($LASTEXITCODE -eq 0) {
                    Write-Host "  [OK] Successfully installed $Id" -ForegroundColor Green
                    # Update cache so we don't prompt again if extension appears in multiple categories
                    $InstalledExtensions.Add($Id.ToLower()) | Out-Null
                } else {
                    Write-Host "  [X] Installation failed with exit code $LASTEXITCODE" -ForegroundColor Red
                    if ($output) {
                        Write-Host "  Error details: $output" -ForegroundColor Red
                    }
                }
            }
            catch {
                Write-Host "  [X] Installation error: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        else {
            Write-Host "  [SKIP] Skipped by user" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "[X] Error checking $Id : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Check if VS Code is available
try {
    $codeVersionOutput = code --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "VS Code command failed"
    }
    Write-Host "VS Code version:" -ForegroundColor Green
    $codeVersionOutput | ForEach-Object { Write-Host "  $_" -ForegroundColor Green }
}
catch {
    Write-Host "`n[X] ERROR: VS Code is not installed or 'code' command not in PATH" -ForegroundColor Red
    Write-Host "Please install VS Code first:" -ForegroundColor Yellow
    Write-Host "  winget install -e --id Microsoft.VisualStudioCode" -ForegroundColor Cyan
    Write-Host "`nIf VS Code is installed, close and reopen your terminal to refresh PATH" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n=== Aqua Lawn VS Code Extensions Installation ===`n" -ForegroundColor Cyan

# Cache installed extensions list for performance (called once instead of 50+ times)
Write-Host "Loading currently installed extensions..." -ForegroundColor Cyan
$installedExtensionsList = code --list-extensions 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[X] Failed to list installed extensions" -ForegroundColor Red
    if ($installedExtensionsList) {
        Write-Host "Error details: $installedExtensionsList" -ForegroundColor Red
    }
    Write-Host "This usually means VS Code is not in PATH or the 'code' command is unavailable" -ForegroundColor Yellow
    exit 1
}

# Convert to lowercase HashSet for fast case-insensitive lookups
$installedExtensionsSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($ext in $installedExtensionsList) {
    $installedExtensionsSet.Add($ext.ToLower()) | Out-Null
}
Write-Host "Found $($installedExtensionsSet.Count) installed extension(s)" -ForegroundColor Green

# ============================================================================
# AI & COPILOT
# ============================================================================
Write-Host "`n=== AI & COPILOT ===`n" -ForegroundColor Magenta

$aiExtensions = @(
    @{Id="anthropic.claude-code";      Desc="Claude Code AI assistant"},
    @{Id="saoudrizwan.claude-dev";     Desc="Claude Dev extension"},
    @{Id="openai.chatgpt";             Desc="ChatGPT integration"},
    @{Id="github.copilot";             Desc="GitHub Copilot"},
    @{Id="github.copilot-chat";        Desc="GitHub Copilot Chat"}
)

foreach ($ext in $aiExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# PYTHON DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== PYTHON DEVELOPMENT ===`n" -ForegroundColor Magenta

$pythonExtensions = @(
    @{Id="ms-python.python";               Desc="Python language support"},
    @{Id="ms-python.debugpy";              Desc="Python debugger"},
    @{Id="ms-python.vscode-pylance";       Desc="Pylance language server"},
    @{Id="ms-python.vscode-python-envs";   Desc="Python environment manager"}
)

foreach ($ext in $pythonExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# C# / .NET DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== C# / .NET DEVELOPMENT ===`n" -ForegroundColor Magenta

$csharpExtensions = @(
    @{Id="ms-dotnettools.csdevkit";                Desc="C# Dev Kit"},
    @{Id="ms-dotnettools.csharp";                  Desc="C# language support"},
    @{Id="ms-dotnettools.vscode-dotnet-runtime";   Desc=".NET runtime installer"}
)

foreach ($ext in $csharpExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# JAVA DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== JAVA DEVELOPMENT ===`n" -ForegroundColor Magenta

$javaExtensions = @(
    @{Id="redhat.java";                        Desc="Java language support by Red Hat"},
    @{Id="vscjava.vscode-java-pack";           Desc="Java extension pack"},
    @{Id="vscjava.vscode-java-debug";          Desc="Java debugger"},
    @{Id="vscjava.vscode-java-dependency";     Desc="Java dependency viewer"},
    @{Id="vscjava.vscode-java-test";           Desc="Java test runner"},
    @{Id="vscjava.vscode-gradle";              Desc="Gradle support"},
    @{Id="vscjava.vscode-maven";               Desc="Maven support"},
    @{Id="vscjava.migrate-java-to-azure";      Desc="Azure migration tools"},
    @{Id="vscjava.vscode-java-upgrade";        Desc="Java upgrade assistant"}
)

foreach ($ext in $javaExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# SQL / DATABASE
# ============================================================================
Write-Host "`n`n=== SQL / DATABASE ===`n" -ForegroundColor Magenta

$sqlExtensions = @(
    @{Id="ms-mssql.mssql";                             Desc="SQL Server support"},
    @{Id="ms-mssql.data-workspace-vscode";             Desc="Data workspace"},
    @{Id="ms-mssql.sql-bindings-vscode";               Desc="SQL bindings"},
    @{Id="ms-mssql.sql-database-projects-vscode";      Desc="SQL database projects"}
)

foreach ($ext in $sqlExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# C/C++ DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== C/C++ DEVELOPMENT ===`n" -ForegroundColor Magenta

$cppExtensions = @(
    @{Id="ms-vscode.cpptools";                 Desc="C/C++ language support"},
    @{Id="ms-vscode.cpptools-extension-pack";  Desc="C/C++ extension pack"},
    @{Id="ms-vscode.cpptools-themes";          Desc="C/C++ themes"},
    @{Id="ms-vscode.cmake-tools";              Desc="CMake tools"}
)

foreach ($ext in $cppExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# REMOTE DEVELOPMENT
# ============================================================================
Write-Host "`n`n=== REMOTE DEVELOPMENT ===`n" -ForegroundColor Magenta

$remoteExtensions = @(
    @{Id="ms-vscode-remote.remote-containers";           Desc="Remote - Containers"},
    @{Id="ms-vscode-remote.remote-ssh";                  Desc="Remote - SSH"},
    @{Id="ms-vscode-remote.remote-ssh-edit";             Desc="Remote - SSH: Editing"},
    @{Id="ms-vscode-remote.remote-wsl";                  Desc="Remote - WSL"},
    @{Id="ms-vscode-remote.vscode-remote-extensionpack"; Desc="Remote Development extension pack"},
    @{Id="ms-vscode.remote-explorer";                    Desc="Remote Explorer"},
    @{Id="ms-vscode.remote-server";                      Desc="Remote Server"}
)

foreach ($ext in $remoteExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# CONTAINERS & KUBERNETES
# ============================================================================
Write-Host "`n`n=== CONTAINERS & KUBERNETES ===`n" -ForegroundColor Magenta

$containerExtensions = @(
    @{Id="ms-azuretools.vscode-containers";            Desc="Docker containers"},
    @{Id="ms-kubernetes-tools.vscode-kubernetes-tools"; Desc="Kubernetes tools"}
)

foreach ($ext in $containerExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# AUTOHOTKEY
# ============================================================================
Write-Host "`n`n=== AUTOHOTKEY ===`n" -ForegroundColor Magenta

$ahkExtensions = @(
    @{Id="mark-wiemer.vscode-autohotkey-plus-plus"; Desc="AutoHotkey Plus Plus"},
    @{Id="zero-plusplus.vscode-autohotkey-debug";   Desc="AutoHotkey debugger"}
)

foreach ($ext in $ahkExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# OTHER UTILITIES
# ============================================================================
Write-Host "`n`n=== OTHER UTILITIES ===`n" -ForegroundColor Magenta

$utilityExtensions = @(
    @{Id="eamodio.gitlens";                                    Desc="GitLens - Git supercharged"},
    @{Id="dbaeumer.vscode-eslint";                             Desc="ESLint JavaScript linter"},
    @{Id="mechatroner.rainbow-csv";                            Desc="Rainbow CSV"},
    @{Id="redhat.vscode-yaml";                                 Desc="YAML language support"},
    @{Id="ms-vscode.powershell";                               Desc="PowerShell support"},
    @{Id="ms-vscode.notepadplusplus-keybindings";              Desc="Notepad++ keybindings"},
    @{Id="visualstudioexptteam.intellicode-api-usage-examples"; Desc="IntelliCode API usage examples"},
    @{Id="visualstudioexptteam.vscodeintellicode";             Desc="Visual Studio IntelliCode"}
)

foreach ($ext in $utilityExtensions) {
    Install-VSCodeExtensionInteractive -Id $ext.Id -Description $ext.Desc -Required $false -InstalledExtensions $installedExtensionsSet
}

# ============================================================================
# COMPLETION
# ============================================================================
Write-Host "`n=== Installation Complete ===`n" -ForegroundColor Cyan
Write-Host "[OK] = already installed, [SKIP] = skipped by user, [X] = error" -ForegroundColor Gray
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Restart VS Code to activate all installed extensions" -ForegroundColor Cyan
Write-Host "  2. Run step 4: .\4-powershell-modules-setup.ps1" -ForegroundColor Cyan
Write-Host "  3. Run step 5: pip install -r 5-python-requirements.txt" -ForegroundColor Cyan
Write-Host "`nTo view all installed extensions: code --list-extensions" -ForegroundColor Gray
