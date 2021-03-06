function Remove-SingleLineComments($multilineText)
{
    $result = $multilineText -replace '//.*\r\n'
    return $result;
}

function Remove-MultilineComments($text)
{
    $regex = New-Object System.Text.RegularExpressions.Regex("/\*.*?\*/", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $output = $regex.Replace($text, "")
   
    return $output;   
}

function Remove-EmptyLines($text)
{
    $regex = New-Object System.Text.RegularExpressions.Regex("^\s*?$\n", [System.Text.RegularExpressions.RegexOptions]::Multiline)
    $output = $regex.Replace($text, "")
    return $output 
}

function Count-Lines([string]$text)
{
    return $text.Split("`n").Length
}

function Count-Classes([string]$text)
{
    $regex = New-Object System.Text.RegularExpressions.Regex("class\s\w", [System.Text.RegularExpressions.RegexOptions]::Multiline)
    $matches = $regex.Matches($text)
    return $matches.Count;
}

function Get-CodeFileStats()
{
    BEGIN
    {
        Write-Host "test"
    }
    PROCESS
    {
        $filePath = $_

        $content = [System.IO.File]::ReadAllText($filePath)
        
        $allLoc = Count-Lines($content)
        $content = Remove-SingleLineComments($content)
        $content = Remove-MultilineComments($content)
        $content = Remove-EmptyLines($content)
        $loc = Count-Lines($content)
        $filename = [System.IO.Path]::GetFileName($filePath);
        $noClasses = Count-Classes($content)
       
        $totalLoc += $loc
        $totalAllLoc += $allLoc;
        $totalFiles++;
        $totalClasses+=$noClasses
        
        $result = New-Object PSObject
        $result | Add-Member -MemberType NoteProperty -Name "Name" -Value $filename
        $result | Add-Member -MemberType NoteProperty -Name "FullName" -Value $filePath
        $result | Add-Member -MemberType NoteProperty -Name "AllLOC" -Value $allLoc
        $result | Add-Member -MemberType NoteProperty -Name "LOC" -Value $loc
        $result | Add-Member -MemberType NoteProperty -Name "NoClasses" -Value $noClasses
        
        
        Write-Output $result
    }
    END
    {
        Write-Host
        Write-Host "Total LOC     : $totalLoc"
        Write-Host "Total Lines   : $totalAllLoc"       
        Write-Host "No of Files   : $totalFiles"
        Write-Host "No of classes : $totalClasses"
     
        if($totalFiles -ne 1)
        {
            $avgLoc = [int]( $totalLoc / $totalFiles )
            $avgCla = ( $totalClasses / $totalFiles )
        
            Write-Host "Avg no LOC per file     : " + $avgLoc
            Write-Host "Avg no class per file   : " + $avgCla
        }
       
    }
}


function Assert-Equal
{
    #Write-Host "";
    if($exptected -ne $actual)
    {
        Write-Host "TEST FAILED: Exptected $exptected, but was: $actual $message"
    }
    else
    {
        Write-Host "TEST PASSED"
    }
}

function Perform-RemoveSingleLine()
{

       # ************************************************************
       $input = "//TEST"
       $exptected = "";
       $actual = Remove-SingleLineComments($text)
       
       Assert-Equal($exptected, $actual);      
       
       # ************************************************************
       $input = "//TEST
This should stay
       "
       $exptected = "This should stay
       ";
       $actual = Remove-SingleLineComments($input)
       
       Assert-Equal($exptected.Trim(), $actual.Trim());    
       # ************************************************************
       $input = "
/// <summary>
/// This is  Point class
/// </summary>
public class Point{
// this keeps x cooridnates
public int X {get;set;}
// this keeps y cooridnates
public int Y {get;set;}
}

"
       
       $exptected = "
public class Point{
public int X {get;set;}
public int Y {get;set;}
}

"
       $actual = Remove-SingleLineComments($input)
       Assert-Equal($exptected.Trim(), $actual.Trim());    
       
       # ************************************************************
       $filePath = [System.IO.Path]::GetTempFileName()
       [System.IO.File]::WriteAllText($filePath, $input);
    
       $input = [System.IO.File]::ReadAllText($filePath)
       $actual = Remove-SingleLineComments($input)
       Assert-Equal($exptected.Trim(), $actual.Trim()); 
} 
       
function Perform-MultilineCommentsTests()
{
       $input = " public class Test{
    /*
        MultilineComment
    */
    public int Y{get;set;}
/*
        MultilineComment
    */


    public int X{get;set;}
    }"

    $exptected = " public class Test{
    
    public int Y{get;set;}



    public int X{get;set;}
    }"
       $actual = Remove-MultilineComments($input)
       Assert-Equal($exptected.Trim(), $actual.Trim()); 
       
       # *********************************************************
       
        $filePath = [System.IO.Path]::GetTempFileName()
       [System.IO.File]::WriteAllText($filePath, $input);
       $input = [System.IO.File]::ReadAllText($filePath)
       $actual = Remove-MultilineComments($input)
       Assert-Equal($exptected.Trim(), $actual.Trim()); 
}


#Perform-RemoveSingleLine
#Perform-MultilineCommentsTests

#cd "C:\Users\PLMANAW1\DriveStartup\work\StepDesigner\Core\DriveConnector"
 
get-childItem -filter *.cs -recurse | Select-Object -ExpandProperty FullName | Get-CodeFileStats | ft
