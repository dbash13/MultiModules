<#
    .SYNOPSIS
        Active directory module utils
    .NOTES
        Changuelog:
        - 2026/03/30 - v1.0.0: Init
#>

$script:NetworkUtilsPath = Resolve-Path (Join-Path $PSScriptRoot '..\NetworkUtils')

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

