function Get-JiraIDsFromAzureChanges {
    param (
        [Parameter(Mandatory=$false)][ValidateNotNullOrEmpty()]
        [string] $SystemAccessToken,

        [Parameter(Mandatory=$false)][ValidateNotNullOrEmpty()]
        [string] $AzureChangeUrl
    )

    $jiraIDs = @()
    Get-AzureDevopsBuildChanges -SystemAccessToken $SystemAccessToken -AzureChangeUrl $AzureChangeUrl | ForEach-Object {
        Find-JiraIDs ($_) | ForEach-Object {
            $jiraIDs += $_.Value.ToUpper()
        }
    }
    $jiraIDs | Sort-object | Get-Unique -AsString
}