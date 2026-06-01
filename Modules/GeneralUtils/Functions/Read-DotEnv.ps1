function Read-DotEnv {
    <#
    .SYNOPSIS
        Custom function that simulates Python DotENv behaviour
    .DESCRIPTION
        This function will load to environment variables a .env
        file by input file path.
    .PARAMETER FilePath
        Specifies the full File Path of the .env file to load

    #>
    param (
        [Parameter(Mandatory = $true, HelpMessage = ".env path")]
        [System.IO.FileInfo]$FilePath
    )

    $counter = 0
    Get-Content $FilePath | ForEach-Object {
        $line = $_.Trim() #Remove spaces

        #Ignonre comments and take rest
        if ($line -and -not $line.StartsWith("#")) {
            $name, $value = $line -split '=', 2 #Split items by = to have key value
            Set-Content -Path "env:\$(($name).Trim())" -Value $value.Trim() | Out-Null
            $counter++
        }
    } | Out-Null

    return $($counter > 0), $counter
    
}