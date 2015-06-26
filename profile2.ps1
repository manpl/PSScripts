Write-Host "Running profile.ps1 ..."
Write-Host "Switching Debug preferences to Continue... (Previously $DebugPreference)" -foreground green
$DebugPreference = "Continue"
$console = $host.UI.RawUI

(get-host).PrivateData.ErrorBackgroundColor =  $console.BackgroundColor


$promptLength = 25
Function prompt
{
	$pwd = (Get-Location)
	$pr = $pwd.Path
	
	if($pwd.Path.Length -gt $promptLength){
		$l = $pwd.Path.Length
		$pr =  $pwd.Drive.Root + "..." + $pwd.Path.Substring($l-($promptLength- 4));
	}

	Write-Host "PS " -NoNewline -ForegroundColor Gray
	Write-Host "$pr>" -NoNewline -ForegroundColor Yellow
	return " "
}

