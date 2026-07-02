$taskName   = "kk-OakvilleAddressLayer"
$projectDir = $PSScriptRoot
$logFile    = "$projectDir\logs\scheduler.log"

if (-not (Test-Path "$projectDir\logs")) {
    New-Item -ItemType Directory -Path "$projectDir\logs" | Out-Null
}

$action = New-ScheduledTaskAction `
    -Execute "cmd.exe" `
    -Argument "/c cd /d `"$projectDir`" && (python -m addressvault.cli pull oakville --wait && python run.py update) >> `"$logFile`" 2>&1"

# Daily, off-peak. The address-layerist engine never downloads; it reads the
# newest oakville-*.geojson from the vault. So pull first (--wait coalesces onto
# any in-flight pull instead of racing/erroring), then build.
$trigger  = New-ScheduledTaskTrigger -Daily -At "03:30"
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 2) -StartWhenAvailable

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Force

Write-Host "Scheduled '$taskName' to run daily at 03:30."
Write-Host "Log: $logFile"
