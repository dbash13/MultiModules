@{
    RootModule        = 'MSUtils.psm1'
    ModuleVersion     = '1.0.0'
    RequiredModules   = @( 
        @{
            ModuleName = 'GeneralUtils'
            ModuleVersion = '1.0.0'
        }
        )
    FunctionsToExport = @(
        'Convert-LogAnalyticsQueryToObjects',
        'Get-MsClientCredentialsCtx'
    )

    Author       = 'dbash13'
    Description  = 'Microsoft related utilities'

}