####################################################################################
# 
#   Podcasts' downloder
#
####################################################################################


function logMessage([string]$path, [string]$message)
{
    $date = Get-Date
    Write-Host "$date $message"
    Add-Content $path "$date $message"
}

function IsProcessed([string] $downloadDirectory, [string] $filename)
{
    $downloadDirFile = $downloadDirectory + $filename
    return [System.IO.File]::Exists($downloadDirFile);
}


function IsArchived([string] $downloadDirectory, [string] $filename)
{
    $oldFilesDirFile = $downloadDirectory + "OLD\" +  $filename
    return [System.IO.File]::Exists($oldFilesDirFile);
}

function ShouldDownload([string] $downloadDirectory, [string] $filename)
{
    return (IsProcessed $downloadDirectory $filename) -eq $False -and (IsArchived $downloadDirectory $filename) -eq $False;
}


function downloadPodcasts([string]$downloadDirectory, [string]$feedUrl, [string] $logPath)
{
    try
    {
        logMessage $logPath "Downloading podcasts from $feedUrl"
        [Environment]::CurrentDirectory=(Get-Location -PSProvider FileSystem).ProviderPath
        $podcastFeed = [xml](new-object net.webclient).downloadstring($feedUrl)
        $downloaded = 0;
        $found = 0;
      
        $podcastFeed.rss.channel.item | foreach{
            $found++
            $pudDateString = $_.pubDate.Replace("EDT", "").Replace("PDT", "").Replace("PST", "").Replace("EST", "")
            $pubDate = [DateTime]$pudDateString 
            $url = [uri]$_.enclosure.url
            
            if($url -ne $null) # it might be just a message without media
            {                                      
                $filename = $url.Segments[-1]                
                $currentDate = Get-Date
               
                if($pubDate -gt $currentDate.AddDays(-31))
                {
                    $result  = ShouldDownload $downloadDirectory  $filename
                    if($result -eq $True)
                    {
                        $localFilename = $downloadDirectory + $filename
                        logMessage $logPath "Downloading $filename" 
                        (new-object Net.WebClient).DownloadFile($url, $localFilename)
                        $downloaded++
                    }
                    else
                    {
                        logMessage $logPath "$filename already downloaded"
                    }
                } 
            } 
        }

        logMessage $logPath "Found: $found"  
        logMessage $logPath "Downloaded: $downloaded"  
    }
    catch
    {
        logMessage $logPath "Exception $_"
    }
}


$networks = netsh wlan show networks
$networksStr = [string] $networks
$atHome = $networksStr.Contains('Ewa')

if($atHome -eq 0)
{
    Write-Host "Setting proxy"
    
    cd HKCU:\"Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    set-itemproperty . ProxyEnable 1
    cd c:\
}
else
{
     Write-Host "Disabling proxy"
    
    cd HKCU:\"Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    set-itemproperty . ProxyEnable 0
    cd c:\
}


$logPath = "C:\Users\marcin\Downloads\podcasts\podcasts.log"
$downloadPath = "C:\Users\marcin\Downloads\podcasts\"

logMessage  $logPath "Attempting to download podcasts" 

logMessage  $logPath "Attempting to download Hanselminutes podcasts"
downloadPodcasts $downloadPath "http://feeds.feedburner.com/HanselminutesCompleteMP3" $logPath

logMessage  $logPath "Attempting to download dotnetrocks podcasts"
downloadPodcasts $downloadPath "http://www.pwop.com/feed.aspx?show=dotnetrocks&filetype=master" $logPath

logMessage  $logPath "Attempting to deepfriedbytes podcasts"
downloadPodcasts $downloadPath "http://feeds.feedburner.com/deepfriedbytes?format=xml" $logPath

logMessage  $logPath "Attempting to download this Devs life podcasts"
downloadPodcasts $downloadPath "http://feeds.feedburner.com/thisdeveloperslife?format=xml" $logPath


write-host "Finished ---------------------------------"