# Phase 3 — Azure Arc (DC01 + APP01)

## Objective
Onboard on-premises VMs to Azure Arc so they can be managed 
from the Azure portal.

## Prerequisites
- DC01 and APP01 running and domain joined
- Azure resource group rg-stephenlab exists
- VMs have outbound internet access on port 443

## Resources deployed

| Resource | Value          |
|----------|----------------|
| DC01     | Arc-enabled    |
| APP01    | Arc-enabled    |
| Region   | West US        |

## Steps

### 1. Generated onboarding script
Generated via Azure portal: Azure Arc → Machines → Add a machine → 
Add a single server. Used Public endpoint connectivity.

### 2. Ran script on DC01
\`\`\`powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\OnboardingScript.ps1
\`\`\`

### 3. Repeated for APP01
Generated a separate onboarding script for APP01 and ran it.

## Validation
\`\`\`powershell
# Run on each VM
Get-Service himds | Select Name, Status
\`\`\`

Both VMs show Connected in Azure Arc portal.

## Screenshots
- screenshots/phase-03/arc-machines-connected.png

## Time taken
~20 minutes

## References
- https://learn.microsoft.com/azure/azure-arc/servers/overview