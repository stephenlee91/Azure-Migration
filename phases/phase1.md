# Phase 1 — Hybrid identity + RBAC

## Objective
Sync on-premises AD identities to Entra ID and configure 
RBAC roles in Azure.

## Prerequisites
- DC01 promoted and healthy (dcdiag clean)
- Azure subscription with Owner role
- APP01 and WS001 domain-joined

## Steps

### 1. Install Entra Connect on DC01
\```powershell
# Download and install Entra Connect
...
\```

### 2. Configure sync scope
...

### 3. Assign RBAC roles in Azure
...

## Validation

\```powershell
# Confirm users synced to Entra ID
Get-MgUser -Filter "onPremisesSyncEnabled eq true"
\```

![Entra ID showing synced users](../screenshots/phase-01/entra-synced-users.png)

## Issues encountered
- **Problem**: Sync failed with error X
- **Cause**: DNS forwarder on DC01 wasn't configured
- **Fix**: Added 8.8.8.8 as forwarder — see dc01-setup.ps1 line 14

## Time taken
~2 hours

## References
- [Entra Connect docs](https://learn.microsoft.com/entra/identity/hybrid)