# Phase 1 — Hybrid identity + RBAC

## Objective
Sync on-premises Active Directory users to Entra ID using Microsoft 
Entra Connect Sync and establish hybrid identity.

## Prerequisites
- DC01 promoted and healthy
- Azure subscription active
- Resource group rg-stephenlab created

## Infrastructure

| Component         | Value                        |
|-------------------|------------------------------|
| AD Domain         | stephenlab.com               |
| Entra Tenant      | yourtenant.onmicrosoft.com   |
| Sync tool         | Microsoft Entra Connect Sync |
| Synced users      | amartin, bchen, svc-app      |

## Steps

### 1. Created Azure resource group
\`\`\`powershell
New-AzResourceGroup -Name "rg-stephenlab" -Location "westus"
\`\`\`

### 2. Installed Entra Connect Sync on DC01
Downloaded from Microsoft and installed via MSI. Used Express Settings.

### 3. Configured sync
- Connected to Entra ID with onmicrosoft.com admin account
- Connected to AD DS with STEPHEN\Administrator
- Checked 'Continue without matching all UPN suffixes' 
  (stephenlab.com is internal, not a verified public domain)

### 4. Verified sync
Users amartin, bchen, svc-app appeared in Entra ID portal
with On-premises sync enabled = Yes

## Validation
\`\`\`powershell
Get-Service ADSync | Select Name, Status
Get-ADUser -Filter * -SearchBase "OU=Users,OU=Lab,DC=stephenlab,DC=com" |
  Select Name, UserPrincipalName, Enabled
\`\`\`

## Issues encountered

### Cloud Sync agent timeout (HybridIdentityServiceAgentTimeout)
- **Cause**: Cloud Sync agent uses Service Bus (servicebus.windows.net) 
  which was blocked on VMware NAT network
- **Fix**: Switched from Cloud Sync to classic Entra Connect Sync which 
  uses graph endpoints instead of Service Bus
  
### VMware NAT blocking Microsoft endpoints
- **Cause**: VMnet8 NAT was blocking outbound connections to several 
  Microsoft IP ranges
- **Fix**: Switched all VMs from NAT to Bridged networking so VMs get 
  real IPs on the home network (192.168.1.x)

### Gmail account not recognized as tenant admin
- **Cause**: Azure account created with Gmail (live.com identity) which 
  is a guest in the Entra tenant
- **Fix**: Created a native onmicrosoft.com admin account and assigned 
  Global Administrator role

## Screenshots
- screenshots/phase-01/entra-synced-users.png
- screenshots/phase-01/ad-users-computers.png

## Time taken
~3 hours (including troubleshooting)

## References
- https://learn.microsoft.com/entra/identity/hybrid/connect/whatis-azure-ad-connect
