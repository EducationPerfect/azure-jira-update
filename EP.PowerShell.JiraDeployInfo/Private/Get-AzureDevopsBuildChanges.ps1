function Get-AzureDevopsBuildChanges {
    param (
        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
        [string] $SystemAccessToken,

        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()]
        [string] $AzureChangeUrl 
    )
    
    Write-Verbose($AzureChangeUrl)

    $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($SystemAccessToken)"))
    $response = Invoke-RestMethod -Uri $AzureChangeUrl -Headers @{Authorization = "Basic $token" } -Method Get
    Write-Verbose("Azure change response:" + ($response | ConvertTo-Json -Depth 100))

    Write-Verbose("Build changes (artificatDatda)" + ($response.fps.dataProviders.data.'ms.vss-traceability-web.traceability-run-changes-data-provider'.artifactsData | ConvertTo-Json -Depth 100))

    $build_changes = $response.fps.dataProviders.data.'ms.vss-traceability-web.traceability-run-changes-data-provider'.artifactsData | ForEach-Object { $_.artifactVersion.id }

    Write-Verbose("[Build Changes count] " + $build_changes.Count)

    Write-Verbose("[Build Changes] " + ($build_changes | ConvertTo-Json -Depth 100))

    $build_changes
}