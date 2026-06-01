function Get-MsClientCredentialsCtx {
    <#
    .SYNOPSIS
        Gets CTX (context) object login to MS OAUTH2
    .DESCRIPTION
        This function logins to MS OAUTH and return a context object
        with necessary values and headers ready to use.
        Also caches on script var the CTX to further use
    .OUTPUTS
        PSCustomObject: Returns object whit Scope, AccessToken, ExpiresOn and Headers
        ready to use
    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $TenantId,

        [Alias('AppId', 'ApplicationId')]
        [Parameter(Mandatory)]
        [string] $ClientId,

        [Alias('AppSecret')]
        [Parameter(Mandatory)]
        [string] $ClientSecret,

        [Parameter(Mandatory)]
        [string] $Scope
    )
    

    #Init var if not present
    if (-not $script:authCache) { $script:authCache = @{} }

    #If cached JWT still valid, return it
    if ($script:authCache.ContainsKey($scope)) {
        $cache = $script:authCache[$scope]
        
        if ($cache.ExpiresOn -gt (Get-date).AddMinutes(5)) {
            return $cache
        }
    }


    $tokenUri = "https://login.microsoftonline.com/$($tenantId)/oauth2/v2.0/token"

    $body = @{
        client_id     = $clientId
        client_secret = $clientSecret
        grant_type    = "client_credentials"
        scope         = $scope
    } 

    try {
        Log -Info "[AUTH]`t`tTrying to obtain bearer for scope $($scope)"

        $res = Invoke-RestMethod -Method Post -Uri $tokenUri -ContentType "application/x-www-form-urlencoded" `
            -Body $body -SkipHttpErrorCheck -ErrorAction Stop

        $rawRes = $res | ConvertTo-Json 
        if ([string]::IsNullOrWhiteSpace($res.access_token)) {
            throw "NO access token getted. Response: $($rawRes)"
        }

        $expiresOn = (Get-Date).AddSeconds([int]$res.expires_in)
        $headers = @{
            Authorization = "Bearer $($res.access_token)"
            Accept        = "application/json"
        }
        

        $ctx = [PSCustomObject]@{
            Scope       = $scope
            AccessToken = $res.access_token
            ExpiresOn   = $expiresOn
            Headers     = $headers
        }
        $script:authCache[$scope] = $ctx
 
        Log -Info "[AUTH]`t`tGetted successfully JWT bearer for scope $scope"
        return $ctx
        
    } catch {
        Log -KO "[AUTH]`t`tError getting JWT bearer with ClientID $($clientId) and scope $($scope)`r`n$($_.Exception.Message)"
    }
}