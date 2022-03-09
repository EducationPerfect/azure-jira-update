Import-Module (Join-Path "." "EP.PowerShell.JiraDeployInfo") -Force

Write-Verbose ("Forced reloading of functions...now running UpdateAzureDeploymentInformation")

Update-AzureDeploymentInformation -State $Env:JIRA_STATE -EnvironmentType $Env:JIRA_ENVIRONMENT -JiraDomain $Env:JIRA_DOMAIN