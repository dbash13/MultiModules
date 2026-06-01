function Test-ComputerExistsInDc {
    <#
    .SYNOPSIS
        Test if a computer exist on supplied DC

    .PARAMETER ComputerName
        Name of the computer to search
    .PARAMETER Dc
        DC to search on (ex: dc.local.net)
    .PARAMETER LdapBase
        Ldap base query (ex: 'DC=dc,DC=local,DC=net')


    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$ComputerName,
        [Parameter(Mandatory)][string]$Dc,
        [Parameter(Mandatory)][string]$LdapBase
    )

   
    $entry = $null
    $searcher = $null

    try {
        $sam = "$ComputerName`$"
        $root = "LDAP://$Dc/$LdapBase"

        Write-Verbose "[AD] Searching computer '$ComputerName' on DC '$Dc'"

        $entry = New-Object System.DirectoryServices.DirectoryEntry($root)
        $searcher = New-Object System.DirectoryServices.DirectorySearcher($entry)

        $searcher.Filter = "(&(objectClass=computer)(sAMAccountName=$sam))"
        $searcher.PageSize = 1
        $searcher.SearchScope = 'Subtree'

        return [bool]$searcher.FindOne()
    }
    catch {
        Write-Verbose "[AD] LDAP search failed on $($Dc): $($_.Exception.Message)"
        return $false
    }
    finally {
        if ($searcher) { $searcher.Dispose() }
        if ($entry) { $entry.Dispose() }
    }
}
