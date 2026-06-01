function Convert-GraphReportToObjects {
    <#
    .SYNOPSIS 
        Convert report item to ps object inserting row names to each one
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$GraphResponse
    )

    

    #Ensure valid input
    if (-not $GraphResponse.Schema) {
        Log -Err "The supplied obj doesnt have required schema"
        return $null
    }

    $columns = $GraphResponse.Schema.Column
    #$rows = $GraphResponse.Values
    
    $results = New-Object System.Collections.Generic.List[PSObject]

    $results = $GraphResponse.Values | ForEach-Object -Parallel {
        $row = $_
        $itemColumns = $using:columns
        
        $obj = [ordered]@{}
        
        for ($i = 0; $i -lt $itemColumns.Count; $i++) {
            $obj[$itemColumns[$i]] = $row[$i]
        }
        [PSCustomObject]$obj #Pipe gett it
    } #-ThrottleLimit 8

    return $results
}