function Get-BasicAuthCreds {
    param([string]$Username,[string]$Password)
    $AuthString = "{0}:{1}" -f $Username,$Password
    $AuthBytes  = [System.Text.Encoding]::Ascii.GetBytes($AuthString)
    return [Convert]::ToBase64String($AuthBytes)
}

function Get-FromWebJson ($url, $cred) {
    return (Invoke-WebRequest -Uri $url -Headers @{"Authorization"="Basic $cred"}).Content |  ConvertFrom-Json; 
}

$BasicCreds = Get-BasicAuthCreds -Username "####" -Password "#####"

#We should enumerate pages until we have all PRs
$baseUrl = "https://api.github.com/repos/dotnet/corefx/pulls?state=all&base=master&page=12"

    $pullRequests = Get-FromWebJson $baseUrl $BasicCreds

    foreach($pull in $pullRequests){
        Write-Host $pull.title " createdAt: "  $pull.created_at  " by "  $pull.user.login;
        $commits =  Get-FromWebJson $pull.commits_url $BasicCreds
    
        foreach($commit in $commits){
            
            $commitDetails = Get-FromWebJson $commit.url $BasicCreds
            Write-Host "`t" $commitDetails.sha " by " $commitDetails.commit.author.name
            Write-Host "`t`t +" $commitDetails.stats.additions; 
            Write-Host "`t`t -" $commitDetails.stats.deletions;

            foreach($file in $commitDetails.files){
                Write-Host "`t`t`t"  $file.filename
                Write-Host "`t`t`t +" $file.additions; 
                Write-Host "`t`t`t -" $file.deletions;
            }
        }
    }
