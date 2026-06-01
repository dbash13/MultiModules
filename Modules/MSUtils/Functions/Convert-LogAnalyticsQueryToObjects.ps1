function Convert-LogAnalyticsQueryToObjects {
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$LogAnalyticsResponse,

        [Parameter(Mandatory = $false)]
        [string]$TableName = "PrimaryResult"
    )

    # Ensure valid input
    if (-not $LogAnalyticsResponse.tables -or $LogAnalyticsResponse.tables.Count -eq 0) {
        return @()
    }

    $table = $LogAnalyticsResponse.tables | Where-Object { $_.name -eq $TableName } | Select-Object -First 1
    if (-not $table) { $table = $LogAnalyticsResponse.tables | Select-Object -First 1 }

    if (-not $table.columns -or -not $table.rows) {
        return @()
    }

    $columns = @($table.columns | ForEach-Object { $_.name })

    $results = @($table.rows) | ForEach-Object -Parallel {
        $row = $_
        $itemColumns = $using:columns

        $obj = [ordered]@{}
        #Take each colum
        for ($i = 0; $i -lt $itemColumns.Count; $i++) {
            $obj[$itemColumns[$i]] = $row[$i]
        }

        [PSCustomObject]$obj
    }

    return $results
}