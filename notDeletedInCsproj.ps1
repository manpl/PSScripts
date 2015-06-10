$csprojs = get-childItem -Filter *.csproj -Recurse
foreach($proj in $csprojs){
	[xml]$content = get-content $proj.FullName
	$gr = $content.Project.ItemGroup
	$incs = $gr | ? { $_.Content} | Select -Expand Content | ? {$_.Include }

	foreach($it in $incs){
		$fullPath = Join-Path $proj.DirectoryName $it.Include
	
		if ((Test-Path $fullPath) -eq $False ){
			Write-Host $proj.DirectoryName  " -> "  $it.Include
		}
	}
}
