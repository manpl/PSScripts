$processes = get-process  | sort cpu
$max = $processes  | Sort -Property cpu| Select-Object -Last 1 -ExpandProperty CPU
$min = $processes | Select-Object -First 1 -ExpandProperty CPU

Write-Host "Max: $max Min: $min"

$processes | ft -autosize -property Handles,Name,NP,PM,VM,@{Name='Percent';expression={
[int]$repetition = (($_.CPU / ($max)) * 100 / 3)
[string]$g=[char]9608
$g * $repetition
}} 
