function Add-JiraDeploymentInformation {
    <#
    .SYNOPSIS
    Adds deployment information to Jira
    
    .DESCRIPTION
    Submits deployment information to Jira issues so that deployments can be tracked to a CI/CD system
    
    .PARAMETER JiraDomain
    For example something.atlassian.net
    
    .PARAMETER Issues
    List of issues to attach to the deployment information
    
    .PARAMETER AtlassianClientId
    OAuth Client ID for Atlassian which can be generated at https://companyname.atlassian.net/secure/admin/oauth-credentials - Defaults to $env:ATLASSIAN_CLIENT_ID if not set
    
    .PARAMETER AtlassianClientSecret
    OAuth Client Secret for Atlassian which can be generated at https://companyname.atlassian.net/secure/admin/oauth-credentials - Defaults to $env:ATLASSIAN_CLIENT_SECRET if not set
    
    .PARAMETER State
    "Unknown", "Pending", "InProgress", "Cancelled", "Failed", "RolledBack", "Successful"
    
    .PARAMETER DisplayName
    The Display Name used in Jira
    
    .PARAMETER Label
    The Label Name used in Jira
    
    .PARAMETER Url
    The URL that Jira links to
    
    .PARAMETER Description
    Description that is submitted to Jira
    
    .PARAMETER PipelineId
    The PipelineId that's sent to Jira
    
    .PARAMETER PipelineDisplayName
    The Pipeline Display Name for show in Jira
    
    .PARAMETER PipelineUrl
    The Pipeline Url to show in Jira
    
    .PARAMETER EnvironmentId
    The Environment ID that's sent to Jira
    
    .PARAMETER EnvironmentDisplayName
    The Environment Display Name to show in Jira 
    
    .PARAMETER EnvironmentType
    "Unmapped", "Development", "Testing", "Staging", "Production"
    
    .PARAMETER Product
    Name of the product updating the data
    
    .EXAMPLE
    Add-JiraDeploymentInformation -JiraDomain "companyname.atlassian.net" -Issues @("OPS-1118") -State Unknown -DisplayName "test" -Label "test" -Url "https://test.com" -Description "test" -PipelineId "test" -PipelineDisplayName "Test" -PipelineUrl "http://test.com" -EnvironmentId "test" -EnvironmentDisplayName "test" -EnvironmentType "Unmapped" -Product "lolcode"
    
    #>

    [CmdletBinding()]
    param (
        [string]
        $JiraDomain,

        [string[]]
        $Issues,

        [Parameter(Mandatory=$false)][ValidateNotNullOrEmpty()]
        [string] $AtlassianClientId = "$env:ATLASSIAN_CLIENT_ID", 

        [Parameter(Mandatory=$false)][ValidateNotNullOrEmpty()]
        [string] $AtlassianClientSecret = $env:ATLASSIAN_CLIENT_SECRET, 

        [ValidateSet("Unknown", "Pending", "InProgress", "Cancelled", "Failed", "RolledBack", "Successful")]
        [string]
        $State = "Unknown",

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DisplayName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Label,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Url,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Description = "PowerShell",

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PipelineId,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PipelineDisplayName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PipelineUrl,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EnvironmentId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EnvironmentDisplayName,

        [ValidateSet("Unmapped", "Development", "Testing", "Staging", "Production")]
        [string]
        $EnvironmentType = "Unmapped",

        [string]
        $Product = "PowerShell"
    )

    $stateTypes = @{
        "Unknown"    = "unknown";
        "InProgress" = "in_progress";
        "Cancelled"  = "cancelled";
        "Failed"     = "failed";
        "RolledBack" = "rolled_back";
        "Successful" = "successful"
    }

    $bodyObject = @{ # https://developer.atlassian.com/cloud/jira/software/rest/api-group-deployments/#api-deployments-0-1-bulk-post
        deployments      = @(
            @{
                deploymentSequenceNumber = [Int](Get-Date -UFormat "%s");
                updateSequenceNumber     = [Int](Get-Date -UFormat "%s");
                associations             = @(
                    @{
                        associationType = "issueIdOrKeys";
                        values          = $Issues
                    }
                );
                displayName              = $DisplayName;
                url                      = $Url;
                description              = $Description;
                lastUpdated              = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffK");
                label                    = $Label;
                state                    = $stateTypes[$State];
                pipeline                 = @{
                    id          = $PipelineId;
                    displayName = $PipelineDisplayName;
                    url         = $PipelineUrl;
                };
                environment              = @{
                    id          = $EnvironmentId;
                    displayName = $EnvironmentDisplayName;
                    type        = $EnvironmentType.ToLower()
                };
                schemaVersion            = "1.0"
            }
        );
        providerMetadata = @{
            product = $Product
        }
    } 
    
    $body = (New-Object PSObject -Property $bodyObject | ConvertTo-Json -Depth 100)

    $response = Invoke-RestMethod -uri "https://api.atlassian.com/jira/deployments/0.1/cloud/$(Get-AtlassianCloudId -JiraDomain $JiraDomain)/bulk" -Method POST -Body $body -ContentType "application/json" -Headers @{"Authorization" = "Bearer $(Get-AtlassianBearerToken -AtlassianClientId $AtlassianClientId -AtlassianClientSecret $AtlassianClientSecret )" }
    Write-Debug ("[Deployment Reponse] " + ($response | ConvertTo-Json -Depth 100))
    $response
}