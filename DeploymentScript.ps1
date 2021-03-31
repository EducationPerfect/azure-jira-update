Import-Module (Join-Path "." "EP.PowerShell.JiraDeployInfo")
Update-AzureDeploymentInformation -State $Env:JIRA_STATE -Environment $Env:JIRA_ENVIRONMENT -JiraDomain $Env:JIRA_DOMAIN