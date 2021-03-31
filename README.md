Usage
==

Set the following variables in your AzureDevops job : 

- AtlassianClientId from : https://companyname.atlassian.net/secure/admin/oauth-credentials
- AtlassianClientSecret from : https://companyname.atlassian.net/secure/admin/oauth-credentials
- JiraDomain : companyname.atlassian.net

```yaml
resources:
  repositories:
  - repository: JiraDeployInfo
    type: github
    name: educationperfect/azure-jira-update
...
  jobs:
      - deployment: ...
        strategy:
          runOnce:
            preDeploy:
              steps:
                - {template: update-jira.yml@JiraDeployInfo, parameters: { JiraState: "Pending", JiraEnvironment: "Testing"}} 
                # JiraState can be one of "Unknown", "Pending", "InProgress", "Cancelled", "Failed", "RolledBack", "Successful"
                # JiraEnvironment can one of "Unmapped", "Development", "Testing", "Staging", "Production"
            on:
              failure:
                steps:
                  - {template: update-jira.yml@JiraDeployInfo, parameters: { JiraState: "Failed", JiraEnvironment: "Testing" }}
              success: 
                steps:
                  - {template: update-jira.yml@JiraDeployInfo, parameters: { JiraState: "Successful", JiraEnvironment: "Testing" }}
            deploy:
              steps:
                - {template: update-jira.yml@JiraDeployInfo, parameters: { JiraState: "InProgress", JiraEnvironment: "Testing" }}
                ...
```