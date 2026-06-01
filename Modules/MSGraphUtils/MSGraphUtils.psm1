<#
    .SYNOPSIS
       Microsoft Graph Utils

    .NOTES
        Changuelog:
        - 2026/03/30 - v1.0.0: Init
#>



#Load each function
$functionsPath = Join-Path -Path $PSScriptRoot -ChildPath "Functions"

if (Test-Path -Path $functionsPath) {
    $scriptFiles = Get-ChildItem -Path $functionsPath -Filter *.ps1 -Recurse

    foreach ($file in $scriptFiles) {
        try {
            . $file.FullName
        }
        catch {
            Write-Error "Error loading function: $($file.FullName). Error: $_"
        }
    }
}

