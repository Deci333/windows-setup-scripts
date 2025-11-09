# Git Configuration Script
# STEP 2a
# Admin not required
# .\2a-git-setup.ps1
# Last updated: 2025-11-09

Write-Host "=== STEP 2a: Git Configuration ===`n" -ForegroundColor Magenta

# ============================================================================
# CHECK GIT INSTALLATION
# ============================================================================

Write-Host "Checking Git installation..." -ForegroundColor Cyan

try {
    $gitVersion = git --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] $gitVersion" -ForegroundColor Green
    } else {
        throw "Git not found"
    }
}
catch {
    Write-Host "[X] Git is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please run step 2 (2-winget-development.ps1) first to install Git" -ForegroundColor Yellow
    exit 1
}

# ============================================================================
# CHECK EXISTING CONFIGURATION
# ============================================================================

Write-Host "`nChecking existing Git configuration..." -ForegroundColor Cyan

$existingName = git config --global user.name 2>$null
$existingEmail = git config --global user.email 2>$null

if ($existingName -and $existingEmail) {
    Write-Host "[INFO] Git is already configured:" -ForegroundColor Yellow
    Write-Host "  Name:  $existingName" -ForegroundColor Gray
    Write-Host "  Email: $existingEmail" -ForegroundColor Gray

    $reconfigure = Read-Host "`nDo you want to reconfigure Git? (y/N)"
    if ($reconfigure -notmatch '^[Yy]') {
        Write-Host "`nSkipping Git configuration. Existing settings preserved." -ForegroundColor Cyan
        $configureGit = $false
    } else {
        $configureGit = $true
    }
} else {
    $configureGit = $true
}

# ============================================================================
# CONFIGURE GIT IDENTITY
# ============================================================================

if ($configureGit) {
    Write-Host "`n=== Git Identity Configuration ===" -ForegroundColor Magenta
    Write-Host "Your Git identity is used for all commits you make.`n" -ForegroundColor Gray

    # Get user name
    if ($existingName) {
        $defaultName = $existingName
    } else {
        $defaultName = [System.Environment]::UserName
    }

    $userName = Read-Host "Enter your full name [$defaultName]"
    if ([string]::IsNullOrWhiteSpace($userName)) {
        $userName = $defaultName
    }

    # Get user email
    $userEmail = Read-Host "Enter your email address"
    while ([string]::IsNullOrWhiteSpace($userEmail) -or $userEmail -notmatch '^[\w\.-]+@[\w\.-]+\.\w+$') {
        Write-Host "Please enter a valid email address" -ForegroundColor Yellow
        $userEmail = Read-Host "Enter your email address"
    }

    # Configure Git
    Write-Host "`nConfiguring Git..." -ForegroundColor Cyan

    git config --global user.name "$userName"
    git config --global user.email "$userEmail"

    Write-Host "[OK] Git identity configured:" -ForegroundColor Green
    Write-Host "  Name:  $userName" -ForegroundColor Gray
    Write-Host "  Email: $userEmail" -ForegroundColor Gray
}

# ============================================================================
# CONFIGURE GIT SETTINGS
# ============================================================================

Write-Host "`n=== Git Settings Configuration ===" -ForegroundColor Magenta

# Line endings (Windows)
git config --global core.autocrlf true
Write-Host "[OK] Line endings set to Windows (CRLF)" -ForegroundColor Green

# Default branch name
git config --global init.defaultBranch main
Write-Host "[OK] Default branch name set to 'main'" -ForegroundColor Green

# Credential helper (Windows)
git config --global credential.helper manager
Write-Host "[OK] Credential helper set to Windows Credential Manager" -ForegroundColor Green

# Pull behavior (rebase by default to keep history clean)
git config --global pull.rebase false
Write-Host "[OK] Pull behavior set to merge (default)" -ForegroundColor Green

# ============================================================================
# SSH KEY SETUP (OPTIONAL)
# ============================================================================

Write-Host "`n=== SSH Key Setup (Optional) ===" -ForegroundColor Magenta
Write-Host "SSH keys allow you to connect to GitHub/GitLab without entering passwords." -ForegroundColor Gray

$sshKeyPath = "$env:USERPROFILE\.ssh\id_ed25519"

if (Test-Path $sshKeyPath) {
    Write-Host "`n[INFO] SSH key already exists at: $sshKeyPath" -ForegroundColor Yellow
    $viewKey = Read-Host "Do you want to view your public key? (y/N)"

    if ($viewKey -match '^[Yy]') {
        Write-Host "`n=== Your Public SSH Key ===" -ForegroundColor Cyan
        Get-Content "$sshKeyPath.pub"
        Write-Host "`n=== Add this key to GitHub/GitLab ===" -ForegroundColor Yellow
        Write-Host "GitHub: https://github.com/settings/keys" -ForegroundColor Cyan
        Write-Host "GitLab: https://gitlab.com/-/profile/keys" -ForegroundColor Cyan
    }
} else {
    $generateKey = Read-Host "`nDo you want to generate an SSH key now? (y/N)"

    if ($generateKey -match '^[Yy]') {
        Write-Host "`nGenerating SSH key..." -ForegroundColor Cyan

        # Get email for SSH key (use Git email if configured)
        $sshEmail = git config --global user.email 2>$null
        if (-not $sshEmail) {
            $sshEmail = Read-Host "Enter email for SSH key"
        }

        # Ensure .ssh directory exists
        $sshDir = "$env:USERPROFILE\.ssh"
        if (-not (Test-Path $sshDir)) {
            New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
        }

        # Generate SSH key
        ssh-keygen -t ed25519 -C "$sshEmail" -f $sshKeyPath -N ""

        if (Test-Path "$sshKeyPath.pub") {
            Write-Host "[OK] SSH key generated successfully" -ForegroundColor Green

            Write-Host "`n=== Your Public SSH Key ===" -ForegroundColor Cyan
            Get-Content "$sshKeyPath.pub"

            Write-Host "`n=== Add this key to GitHub/GitLab ===" -ForegroundColor Yellow
            Write-Host "1. Copy the key above" -ForegroundColor Gray
            Write-Host "2. GitHub: Go to https://github.com/settings/keys" -ForegroundColor Cyan
            Write-Host "   GitLab: Go to https://gitlab.com/-/profile/keys" -ForegroundColor Cyan
            Write-Host "3. Click 'New SSH key' and paste your key" -ForegroundColor Gray

            # Start SSH agent and add key
            Write-Host "`nStarting SSH agent and adding key..." -ForegroundColor Cyan
            Start-Service ssh-agent
            ssh-add $sshKeyPath
            Write-Host "[OK] SSH key added to agent" -ForegroundColor Green
        } else {
            Write-Host "[X] Failed to generate SSH key" -ForegroundColor Red
        }
    }
}

# ============================================================================
# DISPLAY FINAL CONFIGURATION
# ============================================================================

Write-Host "`n=== Git Configuration Summary ===" -ForegroundColor Magenta
git config --global --list | Select-String -Pattern '^(user\.|core\.|init\.|credential\.|pull\.)'

# ============================================================================
# COMPLETION
# ============================================================================

Write-Host "`n=== Git Setup Complete! ===" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  - Test Git: Create a test repository and make a commit" -ForegroundColor Cyan
Write-Host "  - Reboot PC" -ForegroundColor Cyan
Write-Host "  - Open vs code, and sign in with your git account" -ForegroundColor Cyan
Write-Host "  - Step 8 can now be done if you'd like to jump ahead and come back" -ForegroundColor Cyan
Write-Host "  - WSL Git configuration, see Step 8: 8-wsl-cli-setup.md" -ForegroundColor Cyan
Write-Host "  - or Continue with Step 3: .\3-vscode-extensions.ps1" -ForegroundColor Cyan

