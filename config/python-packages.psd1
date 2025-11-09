# ==================================================================
# Python Packages Configuration
# Centralized configuration for Python packages baseline
# Used by: 5-python-packages-setup.ps1
# Last updated: 2025-11-08
# ==================================================================

@{
    # ================================================================
    # WEB AUTOMATION & SCRAPING
    # ================================================================
    WebAutomation = @(
        @{Name="selenium";          Version="4.38.0"; Desc="Browser automation framework"}
        @{Name="webdriver-manager"; Version="4.0.2";  Desc="Automatic WebDriver management"}
        @{Name="beautifulsoup4";    Version="4.14.2"; Desc="HTML/XML parsing library"}
        @{Name="lxml";              Version="6.0.2";  Desc="Fast XML/HTML processing"}
    )

    # ================================================================
    # DATA PROCESSING
    # ================================================================
    DataProcessing = @(
        @{Name="pandas";   Version="2.3.3"; Desc="Data analysis and manipulation"}
        @{Name="openpyxl"; Version="3.1.5"; Desc="Excel file read/write support"}
    )

    # ================================================================
    # UTILITIES
    # ================================================================
    Utilities = @(
        @{Name="requests";     Version="2.32.5";  Desc="HTTP library for API calls"}
        @{Name="cryptography"; Version="46.0.3";  Desc="Cryptographic primitives"}
        @{Name="schedule";     Version="1.2.2";   Desc="Job scheduling library"}
    )

    # ================================================================
    # MACHINE LEARNING (LARGE PACKAGES - ~5-10GB)
    # ================================================================
    MachineLearning = @(
        @{Name="torch";        Version="2.9.0";  Desc="PyTorch deep learning framework (~2GB)"}
        @{Name="transformers"; Version="4.57.1"; Desc="Hugging Face transformers library (~500MB)"}
        @{Name="accelerate";   Version="1.1.0";  Desc="PyTorch training acceleration"}
    )
}
