function Invoke-GraphPagedReport {
    <#
        .SYNOPSIS
            Invoke a Microsoft Graph request to obtain all paginated report data

        .DESCRIPTION
            Gets all data from the report (all columns and pages) by default
            - Requires that the report returns the TotalRowCount property
            - Requires PowerShell 7+

        .PARAMETER Uri
            Full MS Graph URI whit "https://"
            
        .PARAMETER Headers
            JWT valid headers like:
                $headers = @{
                    Authorization = "Bearer $($res.access_token)"
                    Accept        = "application/json"
                }
            Can be obtained using the function Get-MsClientCredetialsJwt

        .PARAMETER PageSize
            Number of elements to return on each request.
            A good value is 50 (used by default), but can be up to 100

        .PARAMETER LogPrefix
            Log prefix text to add in rows
            - Requires "Log" function from module GeneralUtils

        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri,

        [Parameter(Mandatory)]
        [hashtable]$Headers,

        [int]$PageSize = 50,

        [string]$LogPrefix = 'Graph Report'
    )

    $skip = 0
    $hasMoreData = $true
    $processed = 0
    $totalNotified = $false
    $results = @()

    while ($hasMoreData) {

        $body = @{
            top  = $PageSize
            skip = $skip
        } | ConvertTo-Json

        $response = Invoke-RestMethod `
            -Uri $Uri `
            -Headers $Headers `
            -Method Post `
            -Body $body `
            -ContentType 'application/json' `
            -StatusCodeVariable statusCode

        if ($statusCode -ne 200) {
            throw "[$LogPrefix] Graph call failed with HTTP $statusCode"
        }

        if (-not $totalNotified) {
            Log -Info "[$LogPrefix] TotalRowCount = $($response.TotalRowCount)"
            $totalNotified = $true
        }

        $pageCount = @($response.Values).Count

        if ($pageCount -le 0) {
            break
        }

        $processed += $pageCount
        Log -Info "[$LogPrefix] Processed $processed / $($response.TotalRowCount)"

        $results += $response.Values
        $skip += $PageSize
    }

    return $results
}