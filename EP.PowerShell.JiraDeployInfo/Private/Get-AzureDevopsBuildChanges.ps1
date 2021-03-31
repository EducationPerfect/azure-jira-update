function Get-AzureDevopsBuildChanges {
    param (
        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
        [string] $SystemAccessToken,

        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
        [string] $AzureChangeUrl 
    )
    
    $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($SystemAccessToken)"))
    $response = Invoke-RestMethod -Uri $AzureChangeUrl -Headers @{Authorization = "Basic $token" } -Method Get
    Write-Debug $response
    $build_changes = $response.fps.dataProviders.data.'ms.vss-traceability-web.traceability-run-changes-data-provider'.artifactsData.data | ForEach-Object { $_.message }
    Write-Debug ("[Build Changes] " + $build_changes)
    $build_changes
}