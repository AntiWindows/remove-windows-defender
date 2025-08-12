#!/bin/bash
echo "[!] This will permanently disable Windows Defender (Run as Admin)."
echo "[!] For testing in a VM only!"

# Disable via Group Policy
powershell.exe -Command "Start-Process PowerShell -ArgumentList '
    Set-MpPreference -DisableRealtimeMonitoring \$true;
    Set-MpPreference -DisableBehaviorMonitoring \$true;
    Set-MpPreference -DisableBlockAtFirstSeen \$true;
    Set-MpPreference -DisableIOAVProtection \$true;
    Set-MpPreference -DisableScriptScanning \$true;
    Set-MpPreference -DisableArchiveScanning \$true;
    Set-MpPreference -DisableIntrusionPreventionSystem \$true;
    Set-MpPreference -DisablePrivacyMode \$true;
    Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine \$true;
    New-ItemProperty -Path \"HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows Defender\" -Name \"DisableAntiSpyware\" -Value 1 -Force;
    New-ItemProperty -Path \"HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows Defender\" -Name \"DisableRoutinelyTakingAction\" -Value 1 -Force;
    New-ItemProperty -Path \"HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows Defender\\Real-Time Protection\" -Name \"DisableRealtimeMonitoring\" -Value 1 -Force;
    New-ItemProperty -Path \"HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows Defender\\Spynet\" -Name \"SpyNetReporting\" -Value 0 -Force;
    New-ItemProperty -Path \"HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows Defender\\Spynet\" -Name \"SubmitSamplesConsent\" -Value 2 -Force;
' -Verb RunAs"

# Stop & Disable Defender Services
powershell.exe -Command "Start-Process PowerShell -ArgumentList '
    Stop-Service -Name \"WinDefend\" -Force;
    Set-Service -Name \"WinDefend\" -StartupType Disabled;
    Stop-Service -Name \"Sense\" -Force;
    Set-Service -Name \"Sense\" -StartupType Disabled;
    Stop-Service -Name \"WdNisSvc\" -Force;
    Set-Service -Name \"WdNisSvc\" -StartupType Disabled;
    Stop-Service -Name \"SecurityHealthService\" -Force;
    Set-Service -Name \"SecurityHealthService\" -StartupType Disabled;
' -Verb RunAs"

# Disable Tamper Protection (Win 10/11)
powershell.exe -Command "Start-Process PowerShell -ArgumentList '
    Set-ItemProperty -Path \"HKLM:\\SOFTWARE\\Microsoft\\Windows Defender\\Features\" -Name \"TamperProtection\" -Value 0 -Force;
' -Verb RunAs"

echo "[✓] Windows Defender should now be fully disabled."
echo "[!] Reboot required for changes to take effect."
