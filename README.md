Usage
==

Set the following variables in your AzureDevops job : 

- AtlassianClientId from : https://companyname.atlassian.net/secure/admin/oauth-credentials
- AtlassianClientSecret from : https://companyname.atlassian.net/secure/admin/oauth-credentials
- JiraDomain : companyname.atlassian.net

```yaml
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
                - {template: update-jira.yml@JiraDeployInfo, parameters: { JiraState: "Pending", JiraEnvironment: "Testing", JiraDomain: "companyname.atlassian.net" }} 
                # JiraState can be one of "Unknown", "Pending", "InProgress", "Cancelled", "Failed", "RolledBack", "Successful"
                # JiraEnvironment can one of "Unmapped", "Development", "Testing", "Staging", "Production"
            on:
              failure:
                steps:
                  - {template: update-jira.yml@JiraDeployInfo, parameters: { JiraState: "Failed", JiraEnvironment: "Testing", JiraDomain: "companyname.atlassian.net" }}
              success: 
                steps:
                  - {template: update-jira.yml@JiraDeployInfo, parameters: { JiraState: "Successful", JiraEnvironment: "Testing", JiraDomain: "companyname.atlassian.net" }}
            deploy:
              steps:
                - {template: update-jira.yml@JiraDeployInfo, parameters: { JiraState: "InProgress", JiraEnvironment: "Testing", JiraDomain: "companyname.atlassian.net" }}
                ...
```