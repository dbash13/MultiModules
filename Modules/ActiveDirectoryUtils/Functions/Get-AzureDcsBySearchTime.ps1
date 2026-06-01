function Get-AzureDcsBySearchTime {
    <#
    .SYNOPSIS
        Gets Azure Active Directory DCs ordered by fastest processed time
    .NOTES
        v1.0.0 > 25/03/2025
            First release
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCredential]$Credentials,

        [Parameter(Mandatory)]
        [string]$Domain,

        [Parameter(Mandatory)]
        [string]$Filter,

        [Parameter(Mandatory)]
        [string]$IdentityToSearch,

        [int]$TimeoutMs = 30000
    )
    
    
    Write-Verbose "[AD]`tGetting DCs via LDAP query..."

    $allDcs = Resolve-DnsName "_ldap._tcp.dc._msdcs.$Domain" -Type SRV |
    Where-Object { $_.NameTarget -like $Filter }

    Write-Verbose "[AD]`tLDAP query gives $($allDcs.Count) total results"

    if (-not $allDcs) { return @() }

    return ($allDcs | ForEach-Object -Parallel {


            Import-Module $using:NetworkUtilsPath -Force -ErrorAction Stop
            Import-Module ActiveDirectory

            $dc = $_.NameTarget

            Write-Verbose "Testing TCP 9389 on $dc"

            if (-not (Test-TcpPort -Hostname $dc -Port 9389 -TimeoutMs 1000)) {
                Write-Verbose "Port 9389 unreachable on $dc"
                [PSCustomObject]@{
                    DC      = $dc
                    Success = $false
                    Ms      = $null
                    Message = 'ADWS (9389) not reachable'
                }
                return
            }

            $sw = [System.Diagnostics.Stopwatch]::StartNew()

            try {
                $env:ADPS_LoadDefaultDrive = '0'

                Get-ADUser -Credential $using:Credentials `
                    -Identity $using:IdentityToSearch `
                    -Server $dc `
                    -ErrorAction Stop | Out-Null

                $sw.Stop()

                [PSCustomObject]@{
                    DC      = $dc
                    Success = $true
                    Ms      = [math]::Round($sw.Elapsed.TotalMilliseconds, 2)
                    Message = $null
                }
            }
            catch {
                $sw.Stop()
                [PSCustomObject]@{
                    DC      = $dc
                    Success = $false
                    Ms      = [math]::Round($sw.Elapsed.TotalMilliseconds, 2)
                    Message = $_.Exception.Message
                }
            }

        } -ThrottleLimit 4 |
        Sort-Object `
        @{ Expression = { $_.Success }; Descending = $true },
        @{ Expression = { $_.Ms }; Descending = $false })
}