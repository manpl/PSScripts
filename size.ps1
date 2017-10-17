function Get-Size
{
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)][System.IO.DirectoryInfo]$dir
    )
    $dirs = Get-ChildItem -Directory -Force $dir.FullName
    [double]$dirsSize = ($dirs | %{ Get-Size($_) } | Measure-Object -Sum) -as [double]
    [double]$fileSize = ( Get-ChildItem -File -Force $dir.FullName |  Measure-Object -property length -sum | select -ExpandProperty Sum ) -as [double]
    
    return ($fileSize) + $dirsSize;
    
}


function get-Size2{
 param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)][System.IO.DirectoryInfo]$dir
    )
    $size = (Get-ChildItem -Recurse -File -Force -Path $dir.FullName | Measure-Object -Property length -sum).Sum / 1GB
    $object = New-Object –TypeName PSObject –Prop (@{'Name'=$dir.Name;'Size'=$size;'Fullpath'=$dir.FullName})
    Write-Output $object
}


$computedSizes = (Get-ChildItem C:\Users\marcin\Desktop -Directory) | %{ get-Size2($_) }

$max = $computedSizes  | Sort -Property Size | Select-Object -Last 1 -ExpandProperty Size
$min = $computedSizes | Select-Object -First 1 -ExpandProperty Size

$computedSizes | ft -autosize -property Fullpath,Name,Size,@{Name='Percent';expression={
[int]$repetition = (($_.Size / ($max)) * 100 / 3)
[string]$g=[char]9608
$g * $repetition
}} 

