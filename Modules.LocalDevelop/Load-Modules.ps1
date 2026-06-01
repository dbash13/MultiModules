# Launch to load all modules on parent dir 

$modulesPath = Join-Path -Path $PSScriptRoot -ChildPath "Modules"
$loadOrder = @(
    "GeneralUtils",
    "NetworkUtils", 
    "ActiveDirectoryUtils", 
    "MSGraphUtils"
    )

if (Test-Path $modulesPath) {

    foreach ($moduleName in $loadOrder) {
        $manifestPath = "$modulesPath\$moduleName\$moduleName.psd1"
        try {
            Write-Host "Loading local module: $moduleName..."
            
            Import-Module -Name $manifestPath -Force -ErrorAction Stop
        }
        catch {
            Write-Error "Error loading module $($moduleName):`r`n $($_.Exception.Message)"
        }
    }
    
    Write-Host "`nLoaded all modules successfully" -ForegroundColor Green
}
else {
    Write-Error "Modules path dont found: $modulesPath"
}