@{
    RootModule        = 'GeneralUtils.psm1'
    ModuleVersion     = '1.0.2'
    FunctionsToExport = @(
        'Log',
        'Read-DotEnv'
    )
    
    Author       = 'dbash13'
    Description  = 'General AzureOps modules'
}