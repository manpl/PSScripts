1. Filter files not containing specific string
    ```
        Get-ChildItem | Where-Object { $_ | Select-String -pattern test2 }
    ```

2. Filter files not containing specific string
    ```
         Get-ChildItem | Select-String -NotMatch -Pattern test2
    ```
3. Copy by last write time

    ```
        Get-childitem | sort -property LastWriteTime | %{ cp $_.Name c:\temp;  start-sleep -s 1 }
    ```
