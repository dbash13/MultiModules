@{
  RootModule      = 'ActiveDirectoryUtils.psm1'
  ModuleVersion   = '1.0.4'
  RequiredModules = @(
    @{
      ModuleName = 'NetworkUtils'
      ModuleVersion = '1.0.0'
    }
    )
  FunctionsToExport = @(
    'Get-AzureDcsBySearchTime',
    'Test-ComputerExistsInDc'
    )
        
    Author       = 'dbash13'
    Description  = 'Active directory utils'
}