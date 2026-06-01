
function Log {
    <#
    .SYNOPSIS
        Log timestamp to output streams based on selected param
    .DESCRIPTION
        Calling this function will output the string passed to specified canal
        that can be output, warning, error and KO (finish execution)
    .PARAMETER Info
        Outputs text to standar Write-Output apending a prefix with current timestamp
    .PARAMETER InFunction
        Outputs text to standar Write-Output whitout apending a prefix with current timestamp
    .PARAMETER Warn
        Output input text to Write-Warning apending timestamp
    .PARAMETER Err
        Output input tex to Write-Error apending timestamp whitout throwing exception
    .PARAMETER KO
        Output input text to Write-Error apending timestamp and throwing exception

    .EXAMPLE
        Log "Init script"
        Result: [2026-02-20 13:07:00.000] Init script
    #>

    [CmdletBinding(DefaultParameterSetName = "Info")] #If no option selected, use info by default
    Param(
        [Parameter(ParameterSetName = "Info")]
        [ValidateNotNullOrEmpty()]
        [string]$Info,

        [Parameter(ParameterSetName = "InFunction")]
        [ValidateNotNullOrEmpty()]
        [string]$InFunction,

        [Parameter(ParameterSetName = "KO")]
        [ValidateNotNullOrEmpty()]
        [string]$KO,

        [Parameter(ParameterSetName = "Warning")]
        [ValidateNotNullOrEmpty()]
        [string]$Warn,

        [Parameter(ParameterSetName = "Error")]
        [ValidateNotNullOrEmpty()]
        [string]$Err
    )

    $Time = Get-Date ([System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now, "Romance Standard Time")) -Format "yyyy-MM-dd HH:mm:ss.fff"
    

    switch ($PSCmdlet.ParameterSetName) {
        "Info" { 
            Write-Output "[$Time] $Info"
        }
        "InFunction" {
            Write-Host "$Infunction"
        }
        "Warning" {
            Write-Warning "[$Time] $Warn"
        }
        "Error" {
            Write-Error "[$Time] $Err"
        }
        "KO" {
            $ErrorActionPreference = "SilentlyContinue"
            Get-Command Disconnect* -Module (Get-Module).Name | ForEach-Object {
                Invoke-Expression "$($_.Name) -ErrorAction SilentlyContinue" -ErrorAction SilentlyContinue | Out-Null
            }
            $ErrorActionPreference = "Continue"
            Write-Error "[$Time] $KO"
            Throw $KO
        } 
        Default {}
    }
}