#
# ConfigurationData.ps1
#
@{
    AllNodes = @(
        @{
            NodeName = '*'
            PSDscAllowPlainTextPassword = $true
        },
        @{
            NodeName = 'localhost'
        }
    )
}