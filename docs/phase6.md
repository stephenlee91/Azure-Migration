# Phase 6 — App Service + Key Vault + Managed Identity

## Objective
Migrate the ASP.NET Core app from IIS on APP01 to Azure App Service
and replace hardcoded credentials with Key Vault secrets accessed
via Managed Identity.

## Prerequisites
- VNet deployed (Phase 2)
- VM-SQL01 running with LabDB (Phase 5)
- B1 App Service quota approved in West US

## Resources deployed

| Resource              | Value                              |
|-----------------------|------------------------------------|
| App Service Plan      | asp-stephenlab (B1)                |
| App Service           | app-stephenlab                     |
| URL                   | app-stephenlab.azurewebsites.net   |
| Key Vault             | kv-stephenlab2                     |
| Identity type         | System-assigned Managed Identity   |

## Steps

### 1. Deployed via Bicep
```powershell
az deployment group create
  --resource-group rg-stephenlab
  --template-file infra/bicep/modules/app-service.bicep
  --verbose
```

### 2. Packaged app on APP01
```powershell
Compress-Archive -Path "C:\Apps\LabApp\publish\*"
  -DestinationPath "C:\Apps\LabApp\labapp.zip" -Force
```

### 3. Deployed via ZIP Deploy
```powershell
az webapp deploy
  --resource-group rg-stephenlab
  --name app-stephenlab
  --src-path "C:\Users\steph\Downloads\labapp.zip"
  --type zip
  --verbose
```

### 4. Verified app running
Browsed to https://app-stephenlab.azurewebsites.net and confirmed
the ASP.NET Core MVC app is running in Azure.

## Validation
```powershell
az webapp show
  --resource-group rg-stephenlab
  --name app-stephenlab
  --query "{name:name, state:state, url:defaultHostName}"
  --output table
```

## Issues encountered

### App Service quota limit of 0
- **Cause**: Free Azure account had zero quota for all App Service SKUs
- **Fix**: Requested B1 quota increase via Azure portal Quotas page,
  auto-approved within minutes

### Key Vault name conflict
- **Cause**: First deployment partially created kv-stephenlab before
  failing, blocking reuse of the name in a different region
- **Fix**: Purged the soft-deleted Key Vault and used kv-stephenlab2

## Screenshots
- screenshots/phase-06/app-service-running.png
- screenshots/phase-06/app-running-in-browser.png
- screenshots/phase-06/keyvault-secret.png
- screenshots/phase-06/managed-identity.png

## Time taken
~1 hour (including quota request)

## References
- https://learn.microsoft.com/azure/app-service/overview
- https://learn.microsoft.com/azure/key-vault/general/overview