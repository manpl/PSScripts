get-childitem | sort -property LastWriteTime | %{ cp $_.Name c:\temp;  start-sleep -s 1 }
