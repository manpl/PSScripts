Function Search-Items
{
	[CmdletBinding()]
	Param(
	  [Parameter(Mandatory=$True, Position=1)]
	  [string]$searchPhrase,
	  
	  [Parameter(Mandatory=$False, Position=2)]
	  [string]$filter
	)

	Write-Debug "$searchPhrase - $filter"
	
	if($filter){
		$items = Get-ChildItem -R -Filter $filter 
	}
	else{
		$items = Get-ChildItem -R 
	}
	
	$result = $items | Select-String $searchPhrase 
	$result | Write-Output
}
