$hashDict = @{}
$allFiles = Get-ChildItem -File -Recurse | sort -Descending

foreach($file in $allFiles){

    $hash = Get-FileHash $file 
    
    if($hashDict.ContainsKey($hash.Hash)){
        Write-Host "Duplicate found:" $hash.Path
        Remove-Item $hash.Path
    }
    else{
       $hashDict.Add($hash.Hash, $hash)
    }
}
