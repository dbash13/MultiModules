function New-GraphFileAttachment {
    <#
        .SYNOPSIS
        Custom function to generate Graph Odata Attachments
    #>
    param (
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable] $table,
        
        [Parameter(Mandatory)]
        [string] $fileName,

        [string] $delimiter = ','
    )
    

    $csvLines = $table | ConvertTo-Csv -NoTypeInformation -Delimiter $delimiter

    $csvString = ($csvLines -join "`n")

    $bytes = [Text.Encoding]::UTF8.GetBytes($csvString)
    $b64 = [Convert]::ToBase64String($bytes)

    #https://learn.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http#example-3-create-a-message-with-a-file-attachment-and-send-the-message
    return @{
        "@odata.type" = "#microsoft.graph.fileAttachment"
        name          = $fileName
        contentType   = "text/csv"
        contentBytes  = $b64
    }

}