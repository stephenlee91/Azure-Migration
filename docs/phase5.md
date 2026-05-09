# Phase 5 — VM SQL Server 2022 + Bastion access

## Objective
Deploy a Windows Server VM with SQL Server 2022 in Azure and 
connect securely via Azure Bastion without a public IP.

## Prerequisites
- VNet and Bastion deployed (Phase 2)
- snet-servers subnet available

## Resources deployed

| Resource        | Value              |
|-----------------|--------------------|
| VM name         | VM-SQL01           |
| VM size         | Standard_D2s_v3    |
| OS              | Windows Server 2022|
| SQL version     | SQL Server 2022    |
| Private IP      | 10.0.1.10          |
| Authentication  | Mixed mode         |

## Steps

### 1. Deployed VM via Bicep
```powershell
az deployment group create `
  --resource-group rg-stephenlab `
  --template-file infra/bicep/modules/sql-vm.bicep `
  --parameters adminPassword="***" `
  --parameters subnetId="***"
```

### 2. Connected via Bastion
Connected through Azure portal Bastion without public IP.

### 3. Enabled mixed mode authentication
```powershell
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQLServer" `
  -Name "LoginMode" -Value 2
Restart-Service MSSQLSERVER -Force
```

### 4. Enabled SA account
```powershell
sqlcmd -S localhost -E -Q "ALTER LOGIN sa ENABLE; ALTER LOGIN sa WITH PASSWORD = '***';"
```

### 5. Created LabDB with Employees table
```powershell
sqlcmd -S localhost -E -d LabDB -Q "SELECT COUNT(*) AS EmployeeCount FROM Employees;"
-- Returns: 4
```

## Validation
```powershell
Get-Service MSSQLSERVER | Select Name, Status
sqlcmd -S localhost -E -Q "SELECT @@VERSION"
sqlcmd -S localhost -E -d LabDB -Q "SELECT COUNT(*) AS EmployeeCount FROM Employees;"
```

## Issues encountered

### Invoke-Sqlcmd TrustServerCertificate parameter not found
- **Cause**: Old SqlServer module version loaded in session
- **Fix**: Installed latest SqlServer module and reopened PowerShell

### SA login failing after mixed mode change
- **Cause**: SQL restarted but SA not yet enabled
- **Fix**: Used sqlcmd with Windows auth (-E flag) to enable SA

### Bastion connection timeout
- **Cause**: Browser session issue
- **Fix**: Reconnected via portal

## Screenshots
- screenshots/phase-05/vm-sql01-running.png
- screenshots/phase-05/bastion-connected.png
- screenshots/phase-05/dbemployeecount-sqlversion.png

## Time taken
~45 minutes

## References
- https://learn.microsoft.com/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview