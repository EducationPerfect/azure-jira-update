function Get-AtlassianBearerToken {
    param (
        [Parameter(Mandatory=$false)][ValidateNotNullOrEmpty()]
        [string] $AtlassianClientId = "$env:ATLASSIAN_CLIENT_ID", 

        [Parameter(Mandatory=$false)][ValidateNotNullOrEmpty()]
        [string] $AtlassianClientSecret = $env:ATLASSIAN_CLIENT_SECRET 
    )
    $body = @{
        "audience"      = "api.atlassian.com";
        "grant_type"    = "client_credentials";
        "client_id"     = $AtlassianClientId;
        "client_secret" = $AtlassianClientSecret;
    } | ConvertTo-Json


    $response = Invoke-RestMethod -uri "https://api.atlassian.com/oauth/token" -Method POST -Body $body -ContentType "application/json"
    Write-Debug "[Got Auth]"
    $response.access_token
}
