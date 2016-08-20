Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$filename,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$regex
)


 Get-ChildItem $filename | Select-String -Pattern $regex | %{ $_.Matches.Value } | Write-Output



