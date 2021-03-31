function Get-AtlassianCloudId {
    param (
        [string]
        $JiraDomain
    )
    $response = Invoke-RestMethod -uri "https://$JiraDomain/_edge/tenant_info"
    Write-Debug ("[JIRA CLOUD RESPONSE] " + $response)
    Write-Debug ("[JIRA CLOUD ID] " + $response.cloudId)
    $response.cloudId
}
