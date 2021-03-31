Import-Module (Join-Path "." "EP.PowerShell.JiraDeployInfo")
Update-AzureDeploymentInformation -State $Env:JIRA_STATE -EnvironmentType $Env:JIRA_ENVIRONMENT -JiraDomain $Env:JIRA_DOMAIN