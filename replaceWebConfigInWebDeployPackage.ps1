	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True, Position=1)]
		[string]$packagePath,
		[Parameter(Mandatory=$True, Position=2)]
		[string]$configPath
	)

	Add-Type -Assembly System.IO.Compression.FileSystem

	$pwd = Get-Location
	$tempDir = Join-Path $pwd "temp_build"
	Write-Debug "Running in $pwd"
	
	if((Test-Path $packagePath) -eq $false){
		Write-Output "'$packagePath' does not exist"
		return
	}

	if((Test-Path $configPath) -eq $false){
		Write-Output "'$configPath' does not exist"
		return
	}

	if(Test-Path $tempDir){
		Write-Debug "Temp directory exists, removing"
		Remove-Item $tempDir -Recurse -Force
	}

	$packagePath = (Resolve-Path $packagePath).Path
	$configPath = (Resolve-Path $configPath).Path

	New-Item -ItemType directory $tempDir
	
	Write-Debug "Unziping package to '$tempDir'"
	[System.IO.Compression.ZipFile]::ExtractToDirectory($packagePath, $tempDir)
	$oldWebconfig = Get-ChildItem -Path $tempDir -Filter "Web.config" -Recurse
	
	Write-Debug "Copying webconfig to temp directory.  $configPath $oldWebconfig"
	Copy-Item $configPath $oldWebconfig.FullName -Force
	
	Write-Debug "Removing old package"
	Remove-Item $packagePath -Force
	Write-Debug "Ziping package to '$packagePath'"
	[System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $packagePath)
