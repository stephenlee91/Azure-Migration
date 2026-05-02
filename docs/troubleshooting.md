# Troubleshooting log

## DC01 — DNS server failure on Resolve-DnsName google.com
- **Cause**: Default gateway set to 192.168.1.1 (home router) instead 
  of VMware NAT gateway 192.168.253.2
- **Fix**: Corrected NIC config to match VMnet8 subnet

## APP01 — IIS 500.19 error code 0x8007000d
- **Cause**: ASP.NET Core hosting bundle silent install skipped 
  IIS module registration
- **Fix**: Reran installer interactively via GUI

## APP01 — winget not found
- **Cause**: winget is not available on Windows Server
- **Fix**: Used direct download URLs and Invoke-WebRequest

## APP01 — dotnet not found after install
- **Cause**: PATH not refreshed in current PowerShell session
- **Fix**: Refreshed PATH manually or reopened PowerShell as Administrator

## APP01 — SQL Server login failed
- **Cause**: SQL Server installed in Windows Authentication only mode
- **Fix**: Enabled mixed mode via registry (LoginMode = 2) 
  and enabled SA account

## APP01 — New-SmbShare account mapping error
- **Cause**: Domain groups not resolvable during share creation
- **Fix**: Used Administrators and Everyone instead

## Phase 1 — Cloud Sync agent HybridIdentityServiceAgentTimeout
- **Cause**: Service Bus endpoints blocked on VMware NAT
- **Fix**: Switched to classic Entra Connect Sync

## Phase 1 — VMware NAT blocking Microsoft endpoints
- **Cause**: VMnet8 NAT blocking outbound to Microsoft IP ranges
- **Fix**: Switched all VMs to Bridged networking

## Phase 1 — Gmail account not recognized as tenant admin
- **Cause**: Gmail is a guest identity in Entra tenant
- **Fix**: Created native onmicrosoft.com Global Administrator account
"@