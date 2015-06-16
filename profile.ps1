Write-Host "Running profile.ps1" -foreground green
#(get-host).PrivateData.ErrorBackgroundColor =  'darkBlue'
(get-host).PrivateData.ErrorForegroundColor =  'green'

Write-Host "Importing module CSCodeStats..." -foreground green
Import-Module CSCodeStats
Write-Host "Switching Debug preferences to Continue... (Previously $DebugPreference)" -foreground green
$DebugPreference = "Continue"
cd C:\Users\PLMANAW1\DriveStartup\work\StepDesigner\Common\Commands

Write-Host "Profile script finished" -foreground green


