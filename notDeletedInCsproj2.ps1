$csprojs = get-childItem -Filter *.csproj -Recurse
foreach($projPath in $csprojs){
	[xml]$proj = get-content $projPath.FullName
	$nsmgr = New-Object System.Xml.XmlNamespaceManager -ArgumentList $proj.NameTable
	$nsmgr.AddNamespace('a','http://schemas.microsoft.com/developer/msbuild/2003')
	$nodes = $proj.SelectNodes('//a:ItemGroup/a:Content[@Include]', $nsmgr)
	foreach($inc in $nodes){
		$fullPath = Join-Path $projPath.DirectoryName $inc.Include
		if ((Test-Path $fullPath) -eq $False ){
			Write-Host $projPath.DirectoryName  " -> "  $inc.Include
		}
	}
}
