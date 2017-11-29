
#
# install_web_app_with_octo_dsc.ps1
#
Configuration SampleConfig
{
    param ($ApiKey, $OctopusServerUrl, $Environments, $Roles, $ListenPort)

    Import-DscResource -Module OctopusDSC

    Node "localhost"
    {
        cTentacleAgent OctopusTentacle
        {
            Ensure = "Present"
            State = "Started"

			CommunicationMode = "Poll"
			ListenPort = $ListenPort

            # Tentacle instance name. Leave it as 'Tentacle' unless you have more
            # than one instance
            Name = "Tentacle"

            # Defaults to <MachineName>_<InstanceName> unless overridden
            DisplayName = "My Tentacle"

            # Required parameters. See full properties list below
            ApiKey = $ApiKey
            OctopusServerUrl = $OctopusServerUrl
            Environments = $Environments
            Roles = $Roles
        }
    }
}

SampleConfig -ApiKey "API-9WX6OWHFA66M6NAGOINAE5KMLP0" -OctopusServerUrl "https://52.160.90.144/" -Environments @("Dev") -Roles @("web-server") -ListenPort 10934

Start-DscConfiguration .\SampleConfig -Verbose -wait

Test-DscConfiguration