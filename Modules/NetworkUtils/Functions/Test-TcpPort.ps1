function Test-TcpPort {
    <#
    .SYNOPSIS
        Test connectivity to TCP port

    .NOTES
        Changuelog:
        - 2026/03/26 - v1.0.0: First release
    #>
    param(
        [string]$Hostname,
        [int]$Port,
        [int]$TimeoutMs = 1000
    )

    
    $client = [System.Net.Sockets.TcpClient]::new()
    try {
        $task = $client.ConnectAsync($Hostname, $Port)

        if (-not $task.Wait($TimeoutMs)) {
            return $false
        }

        return $client.Connected
    }
    catch {
        return $false
    }
    finally {
        $client.Dispose()
    }
}