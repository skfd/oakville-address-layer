$taskName   = "kk-OakvilleAddressLayer"
$projectDir = $PSScriptRoot
$logFile    = "$projectDir\logs\scheduler.log"

if (-not (Test-Path "$projectDir\logs")) {
    New-Item -ItemType Directory -Path "$projectDir\logs" | Out-Null
}

# A git process killed mid-write (a torn-down container with Code/ mounted is the
# usual culprit) leaves a zero-byte *.lock behind, and publish then fails every day
# until someone clears it by hand -- that cost four days of updates in July 2026.
# Sweep first, best-effort: joined with & so a hiccup here can never block the build.
$lockCheck = Join-Path (Split-Path $projectDir -Parent) "check-git-locks.ps1"
if (-not (Test-Path $lockCheck)) { Write-Warning "Lock sweeper not found: $lockCheck" }

$action = New-ScheduledTaskAction `
    -Execute "cmd.exe" `
    -Argument "/c cd /d `"$projectDir`" && (powershell -NoProfile -ExecutionPolicy Bypass -File `"$lockCheck`" -Clear & python -m addressvault.cli pull oakville --wait && python run.py update) >> `"$logFile`" 2>&1"

# Daily at 17:00, matching the registered task. Nothing is ever scheduled between
# 00:00 and 06:30. The address-layerist engine never downloads; it reads the newest
# oakville-*.geojson from the vault. So pull first (--wait coalesces onto any
# in-flight pull instead of racing/erroring), then build.
$trigger  = New-ScheduledTaskTrigger -Daily -At "17:00"
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 2) -StartWhenAvailable

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Force

Write-Host "Scheduled '$taskName' to run daily at 17:00."
Write-Host "Log: $logFile"
