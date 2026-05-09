# Phase 10 — IaC (Bicep) + GitHub Actions CI/CD

## Objective
Consolidate all infrastructure into a single orchestrated Bicep deployment
and automate it via GitHub Actions using OIDC authentication.

## Prerequisites
- All phases 1-9 complete
- GitHub repository set up
- Azure service principal created

## Resources

| Resource                  | Value                              |
|---------------------------|------------------------------------|
| Service principal         | github-actions-stephenlab          |
| Auth method               | OIDC (no stored secrets)           |
| Workflow file             | .github/workflows/deploy.yml       |
| Orchestration template    | infra/bicep/main.bicep             |

## Steps

### 1. Created main.bicep orchestration template
Single entry point that calls all module Bicep files:
- modules/vnet.bicep
- modules/sql-vm.bicep
- modules/app-service.bicep
- modules/storage.bicep
- modules/recovery-vault.bicep
- modules/monitoring.bicep

### 2. Created service principal for GitHub Actions
\`\`\`powershell
az ad app create --display-name "github-actions-stephenlab"
az ad sp create --id \$appId
az role assignment create \`
  --role "Owner" \`
  --assignee \$spId \`
  --scope "/subscriptions/\$subId/resourceGroups/rg-stephenlab"
\`\`\`

### 3. Configured OIDC federated credentials
\`\`\`powershell
# Main branch credential
az ad app federated-credential create \`
  --id \$appId \`
  --parameters federated-credential.json

# Production environment credential
az ad app federated-credential create \`
  --id \$appId \`
  --parameters federated-credential-prod.json
\`\`\`

### 4. Added GitHub secrets
- AZURE_CLIENT_ID
- AZURE_TENANT_ID
- AZURE_SUBSCRIPTION_ID
- SQL_ADMIN_PASSWORD
- SUBNET_ID

### 5. Created GitHub Actions workflow
Two-job pipeline:
- validate: builds Bicep to check for errors
- deploy: deploys via azure/arm-deploy action

### 6. Created production environment in GitHub
Required for the deploy job OIDC subject claim.

## Issues encountered

### Federated credential subject mismatch
- **Cause**: Repo name in credential didn't match actual GitHub repo name
- **Fix**: Deleted and recreated credential with correct repo name

### Policy blocking NIC and VM deployment
- **Cause**: Tagging policy assigned in Phase 9 was blocking resources
  without Environment tag during redeployment
- **Fix**: Removed tagging policy before CI/CD deployment. In production
  tags would be added to all resources before enabling deny policies.

### Role assignment authorization failed
- **Cause**: Service principal had Contributor role which cannot manage
  role assignments
- **Fix**: Upgraded to Owner role on the resource group

## Validation
Both GitHub Actions jobs completed successfully:
- Validate Bicep: passed
- Deploy infrastructure: succeeded

## Screenshots
- screenshots/phase-10/github-actions-success.png

## Time taken
~1.5 hours (including troubleshooting)

## References
- https://learn.microsoft.com/azure/developer/github/connect-from-azure
- https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview