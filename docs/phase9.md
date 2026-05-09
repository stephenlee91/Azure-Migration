# Phase 9 — Security · Monitor · Policy · App Insights

## Objective
Configure security monitoring, application performance monitoring,
alert rules, and Azure Policy for the lab environment.

## Prerequisites
- All resources deployed (Phases 1-8)
- App Service running (Phase 6)
- VM-SQL01 running (Phase 5)

## Resources deployed

| Resource                  | Value                              |
|---------------------------|------------------------------------|
| Log Analytics Workspace   | log-stephenlab                     |
| Application Insights      | appi-stephenlab                    |
| Alert — HTTP 5xx          | alert-http5xx-stephenlab           |
| Alert — VM CPU            | alert-cpu-sql01                    |
| Policy — Tagging          | Require Environment tag            |
| Policy — Security         | Azure Security Benchmark           |

## Steps

### 1. Enabled Microsoft Defender for Cloud
```powershell
az security pricing create --name VirtualMachines --tier Standard
az security pricing create --name SqlServers --tier Standard
az security pricing create --name AppServices --tier Standard
```

### 2. Deployed monitoring via Bicep
```powershell
az deployment group create `
  --resource-group rg-stephenlab `
  --template-file infra/bicep/modules/monitoring.bicep `
  --verbose
```

### 3. Assigned Azure Policy initiatives
```powershell
az policy assignment create `
  --name "require-environment-tag" `
  --display-name "Require Environment tag on resources" `
  --policy "871b6d14-10aa-478d-b590-94f262ecfa99" `
  --scope "/subscriptions/$subId/resourceGroups/rg-stephenlab" `
  --params "tag-params.json"
```

# Security benchmark
```powershell
az policy assignment create `
  --name "azure-security-benchmark" `
  --display-name "Azure Security Benchmark" `
  --policy-set-definition "1f3afdf9-d0c9-4c3d-847f-89da613e70a8" `
  --scope "/subscriptions/\$subId/resourceGroups/rg-stephenlab"
```

## Validation
```powershell
az monitor app-insights component show `
  --resource-group rg-stephenlab `
  --app appi-stephenlab `
  --query "{name:name, provisioningState:provisioningState}" `
  --output table

az policy assignment list `
  --scope "/subscriptions/\$subId/resourceGroups/rg-stephenlab" `
  --query "[].{name:name, displayName:displayName}" `
  --output table
```

## Screenshots
- screenshots/phase-09/defender-secure-score.png
- screenshots/phase-09/app-insights-overview.png
- screenshots/phase-09/alert-rules.png
- screenshots/phase-09/policy-assignments.png

## Time taken
~30 minutes

## References
- https://learn.microsoft.com/azure/defender-for-cloud/defender-for-cloud-introduction
- https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview
- https://learn.microsoft.com/azure/governance/policy/overview