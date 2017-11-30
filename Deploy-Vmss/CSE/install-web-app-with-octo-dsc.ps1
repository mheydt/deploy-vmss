
#
# install_web_app_with_octo_dsc.ps1
#
Configuration SampleConfig
{
    param ($ApiKey, $OctopusServerUrl, $Environments, $Roles, $ServerPort)

    Import-DscResource -Module OctopusDSC

    Node "localhost"
    {
        cTentacleAgent OctopusTentacle
        {
            Ensure = "Present"
            State = "Started"

            Name = "Tentacle"

			CommunicationMode = "Poll"
			ServerPort = $ServerPort
			#OctopusServerThumbprint = "E51CABA6C115C3DB0343391E58916AA7BBC5E503"

            ApiKey = $ApiKey
            OctopusServerUrl = $OctopusServerUrl
            Environments = $Environments
            Roles = $Roles

			DefaultApplicationDirectory = "C:\Applications"
        }
    }
}

SampleConfig -ApiKey "API-9WX6OWHFA66M6NAGOINAE5KMLP0" -OctopusServerUrl "https://52.160.90.144/" -Environments @("Dev") -Roles @("web-server") -ServerPort 10943

Start-DscConfiguration .\SampleConfig -Verbose -wait

Test-DscConfiguration