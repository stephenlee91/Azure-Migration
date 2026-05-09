# Phase 8 — Backup (SQL + App Service)

## Objective
Configure Azure Recovery Services Vault to back up VM-SQL01
and App Service.

## Prerequisites
- VM-SQL01 running (Phase 5)
- App Service deployed (Phase 6)
- Storage account available (Phase 7)

## Resources deployed

| Resource                | Value              |
|-------------------------|--------------------|
| Recovery Services Vault | rsv-stephenlab     |
| Backup policy           | policy-sql-daily   |
| Retention               | 30 days            |
| Schedule                | Daily at 2:00 AM   |

## Steps

### 1. Deployed Recovery Services Vault via Bicep
```powershell
az deployment group create
  --resource-group rg-stephenlab
  --template-file infra/bicep/modules/recovery-vault.bicep
  --verbose
```

### 2. Enabled backup for VM-SQL01
```powershell
az backup protection enable-for-vm
  --resource-group rg-stephenlab
  --vault-name rsv-stephenlab
  --vm VM-SQL01
  --policy-name policy-sql-daily
```

### 3. Ran on-demand backup job
Triggered immediate backup for VM-SQL01 and verified job
completed successfully in the Recovery Vault jobs list.

### 4. App Service backup — known limitation
App Service backup requires Standard SKU or higher.
The lab uses B1 Basic due to free account quota constraints.

In a production environment the App Service would run on
Standard or Premium tier enabling:
- Automated scheduled backups
- Retention policies
- Point-in-time restore

## Validation
```powershell
az backup vault show
  --resource-group rg-stephenlab
  --vault-name rsv-stephenlab
  --query "{name:name, provisioningState:properties.provisioningState}"
  --output table
```

## Screenshots
- screenshots/phase-08/recovery-vault-overview.png
- screenshots/phase-08/vm-sql01-backup-policy.png

## Time taken
~20 minutes

## References
- https://learn.microsoft.com/azure/backup/backup-azure-vms-introduction
- https://learn.microsoft.com/azure/app-service/manage-backup