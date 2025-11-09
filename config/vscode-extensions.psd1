# ==================================================================
# VS Code Extensions Configuration
# Centralized configuration for VS Code extensions baseline
# Used by: 3-vscode-extensions.ps1
# Last updated: 2025-11-08
# ==================================================================

@{
    # ================================================================
    # AI & COPILOT
    # ================================================================
    AI = @(
        @{Id="anthropic.claude-code";      Desc="Claude Code AI assistant"}
        @{Id="saoudrizwan.claude-dev";     Desc="Claude Dev extension"}
        @{Id="openai.chatgpt";             Desc="ChatGPT integration"}
        @{Id="github.copilot";             Desc="GitHub Copilot"}
        @{Id="github.copilot-chat";        Desc="GitHub Copilot Chat"}
    )

    # ================================================================
    # PYTHON DEVELOPMENT
    # ================================================================
    Python = @(
        @{Id="ms-python.python";               Desc="Python language support"}
        @{Id="ms-python.debugpy";              Desc="Python debugger"}
        @{Id="ms-python.vscode-pylance";       Desc="Pylance language server"}
        @{Id="ms-python.vscode-python-envs";   Desc="Python environment manager"}
    )

    # ================================================================
    # C# / .NET DEVELOPMENT
    # ================================================================
    CSharp = @(
        @{Id="ms-dotnettools.csdevkit";                Desc="C# Dev Kit"}
        @{Id="ms-dotnettools.csharp";                  Desc="C# language support"}
        @{Id="ms-dotnettools.vscode-dotnet-runtime";   Desc=".NET runtime installer"}
    )

    # ================================================================
    # JAVA DEVELOPMENT
    # ================================================================
    Java = @(
        @{Id="redhat.java";                        Desc="Java language support by Red Hat"}
        @{Id="vscjava.vscode-java-pack";           Desc="Java extension pack"}
        @{Id="vscjava.vscode-java-debug";          Desc="Java debugger"}
        @{Id="vscjava.vscode-java-dependency";     Desc="Java dependency viewer"}
        @{Id="vscjava.vscode-java-test";           Desc="Java test runner"}
        @{Id="vscjava.vscode-gradle";              Desc="Gradle support"}
        @{Id="vscjava.vscode-maven";               Desc="Maven support"}
        @{Id="vscjava.migrate-java-to-azure";      Desc="Azure migration tools"}
        @{Id="vscjava.vscode-java-upgrade";        Desc="Java upgrade assistant"}
    )

    # ================================================================
    # SQL / DATABASE
    # ================================================================
    SQL = @(
        @{Id="ms-mssql.mssql";                             Desc="SQL Server support"}
        @{Id="ms-mssql.data-workspace-vscode";             Desc="Data workspace"}
        @{Id="ms-mssql.sql-bindings-vscode";               Desc="SQL bindings"}
        @{Id="ms-mssql.sql-database-projects-vscode";      Desc="SQL database projects"}
    )

    # ================================================================
    # C/C++ DEVELOPMENT
    # ================================================================
    CPP = @(
        @{Id="ms-vscode.cpptools";                 Desc="C/C++ language support"}
        @{Id="ms-vscode.cpptools-extension-pack";  Desc="C/C++ extension pack"}
        @{Id="ms-vscode.cpptools-themes";          Desc="C/C++ themes"}
        @{Id="ms-vscode.cmake-tools";              Desc="CMake tools"}
    )

    # ================================================================
    # REMOTE DEVELOPMENT
    # ================================================================
    RemoteDevelopment = @(
        @{Id="ms-vscode-remote.remote-containers";           Desc="Remote - Containers"}
        @{Id="ms-vscode-remote.remote-ssh";                  Desc="Remote - SSH"}
        @{Id="ms-vscode-remote.remote-ssh-edit";             Desc="Remote - SSH: Editing"}
        @{Id="ms-vscode-remote.remote-wsl";                  Desc="Remote - WSL"}
        @{Id="ms-vscode-remote.vscode-remote-extensionpack"; Desc="Remote Development extension pack"}
        @{Id="ms-vscode.remote-explorer";                    Desc="Remote Explorer"}
        @{Id="ms-vscode.remote-server";                      Desc="Remote Server"}
    )

    # ================================================================
    # CONTAINERS & KUBERNETES
    # ================================================================
    Containers = @(
        @{Id="ms-azuretools.vscode-containers";            Desc="Docker containers"}
        @{Id="ms-kubernetes-tools.vscode-kubernetes-tools"; Desc="Kubernetes tools"}
    )

    # ================================================================
    # AUTOHOTKEY
    # ================================================================
    AutoHotkey = @(
        @{Id="mark-wiemer.vscode-autohotkey-plus-plus"; Desc="AutoHotkey Plus Plus"}
        @{Id="zero-plusplus.vscode-autohotkey-debug";   Desc="AutoHotkey debugger"}
    )

    # ================================================================
    # OTHER UTILITIES
    # ================================================================
    Utilities = @(
        @{Id="eamodio.gitlens";                                    Desc="GitLens - Git supercharged"}
        @{Id="dbaeumer.vscode-eslint";                             Desc="ESLint JavaScript linter"}
        @{Id="mechatroner.rainbow-csv";                            Desc="Rainbow CSV"}
        @{Id="redhat.vscode-yaml";                                 Desc="YAML language support"}
        @{Id="ms-vscode.powershell";                               Desc="PowerShell support"}
        @{Id="ms-vscode.notepadplusplus-keybindings";              Desc="Notepad++ keybindings"}
        @{Id="visualstudioexptteam.intellicode-api-usage-examples"; Desc="IntelliCode API usage examples"}
        @{Id="visualstudioexptteam.vscodeintellicode";             Desc="Visual Studio IntelliCode"}
    )
}
