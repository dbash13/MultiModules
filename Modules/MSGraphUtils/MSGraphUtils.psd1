@{
    RootModule        = 'MSGraphUtils.psm1'
    ModuleVersion     = '1.0.4'
    RequiredModules   = @( 
        @{
            ModuleName = 'GeneralUtils'
            ModuleVersion = '1.0.0'
        },
        @{
            ModuleName = 'MSUtils'
            ModuleVersion = '1.0.0'
        }
        )
    FunctionsToExport = @(
        'Convert-GraphReportToObjects',
        'Invoke-GraphPagedReport'
    )

    Author       = 'dbash13'
    Description  = 'Microsoft Graph related utilities'

}