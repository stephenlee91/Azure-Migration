## DC01 — DNS server failure on Resolve-DnsName google.com
- **Phase**: DC01 setup
- **Symptom**: Resolve-DnsName google.com returned a DNS server failure
- **Cause**: Default gateway set to 192.168.1.1 (home router) instead
  of VMware NAT gateway 192.168.253.2
- **Fix**: Corrected NIC config to match VMnet8 subnet. Updated IP to
  192.168.253.10 with gateway 192.168.253.2

## DC01 — No internet icon showing in taskbar
- **Phase**: DC01 setup
- **Symptom**: Windows showing no internet connectivity icon
- **Cause**: Normal behavior on domain controllers. NLA service probes
  msftconnecttest.com which fails when DNS points to 127.0.0.1
- **Fix**: Not required — DNS and internet connectivity confirmed working
  via ping and Resolve-DnsName

## APP01 — winget not found
- **Phase**: APP01 setup
- **Symptom**: winget command not recognized
- **Cause**: winget is a Windows 10/11 client tool, not available on
  Windows Server
- **Fix**: Used direct download URLs and Invoke-WebRequest instead

## APP01 — dotnet not found after install
- **Phase**: APP01 setup
- **Symptom**: dotnet command not recognized after installing .NET 8 SDK
- **Cause**: PATH environment variable not refreshed in current session
- **Fix**: Refreshed PATH manually or reopened PowerShell as Administrator

## APP01 — IIS 500.19 error code 0x8007000d
- **Phase**: APP01 setup
- **Symptom**: IIS returning 500.19 Internal Server Error on every request
- **Cause**: ASP.NET Core hosting bundle silent install skipped IIS module
  registration. aspnetcorev2.dll was missing from both IIS module paths
- **Fix**: Reran the hosting bundle installer interactively via GUI which
  correctly registered AspNetCoreModuleV2 with IIS
- **Lesson**: On Windows Server always run the hosting bundle installer
  interactively — silent flags can skip IIS registration

## APP01 — SQL Server login failed for APP01\Administrator
- **Phase**: APP01 setup
- **Symptom**: Invoke-Sqlcmd failing with login error
- **Cause**: SQL Server installed in Windows Authentication only mode.
  Mixed mode not enabled by default
- **Fix**: Enabled mixed mode via registry (LoginMode = 2), restarted
  SQL Server, then enabled SA account

## APP01 — Invoke-Sqlcmd SSL certificate error
- **Phase**: APP01 setup
- **Symptom**: SSL Provider error on Invoke-Sqlcmd connection
- **Cause**: SQL Server 2022 enforces encrypted connections by default
- **Fix**: Added -TrustServerCertificate flag to all Invoke-Sqlcmd calls

## APP01 — New-SmbShare account mapping error
- **Phase**: APP01 setup
- **Symptom**: No mapping between account names and security IDs
- **Cause**: Domain group names not resolvable during share creation
- **Fix**: Used Administrators and Everyone instead of domain groups

## APP01 — SQL2022-SSEI-Expr.exe not accepting install flags
- **Phase**: APP01 setup
- **Symptom**: Settings like instancename not recognized
- **Cause**: The downloaded file is a bootstrapper, not the full installer
- **Fix**: Used bootstrapper to download full media first, then ran
  setup.exe from extracted files with correct flags

## Phase 1 — Cloud Sync agent HybridIdentityServiceAgentTimeout
- **Phase**: Hybrid identity
- **Symptom**: Cloud Sync agent timing out, stuck in Quarantine state
- **Cause**: Cloud Sync uses Service Bus (servicebus.windows.net) which
  was blocked on VMware NAT network
- **Fix**: Switched from Cloud Sync agent to classic Entra Connect Sync
  which uses graph endpoints instead of Service Bus

## Phase 1 — VMware NAT blocking Microsoft endpoints
- **Phase**: Hybrid identity
- **Symptom**: Test-NetConnection failing for servicebus.windows.net
  and other Microsoft endpoints
- **Cause**: VMnet8 NAT blocking outbound connections to specific
  Microsoft IP ranges
- **Fix**: Switched all VMs from NAT to Bridged networking so VMs get
  real IPs on the home network (192.168.1.x) with direct internet access

## Phase 1 — Gmail account not recognized as tenant admin
- **Phase**: Hybrid identity
- **Symptom**: AADSTS50020 error — account from identity provider
  live.com does not exist in tenant
- **Cause**: Azure account created with Gmail which is a guest identity
  in the Entra tenant, not a native account
- **Fix**: Created a native onmicrosoft.com admin account and assigned
  Global Administrator role

## Phase 1 — Cloud Sync page access denied
- **Phase**: Hybrid identity
- **Symptom**: You do not have permission to access this page.
  Guest users are not allowed to configure sync
- **Cause**: Logged into Entra portal with Gmail guest account
- **Fix**: Signed out and signed back in with onmicrosoft.com admin account

## Phase 1 — UPN suffix not verified in Entra
- **Phase**: Hybrid identity
- **Symptom**: stephenlab.com showing as Not Added in Entra Connect wizard
- **Cause**: stephenlab.com is an internal AD domain, not a verified
  public domain in Entra ID
- **Fix**: Checked Continue without matching all UPN suffixes. Users sync
  successfully and use onmicrosoft.com UPN for Azure sign-in

## Phase 5 — Bastion connection client timeout
- **Phase**: VM SQL01
- **Symptom**: Bastion connection timing out when trying to connect to VM
- **Cause**: Browser session or authentication type mismatch
- **Fix**: Reconnected via portal ensuring Password authentication type
  selected and correct username sqladmin used

## Phase 5 — Invoke-Sqlcmd TrustServerCertificate not found
- **Phase**: VM SQL01
- **Symptom**: Parameter TrustServerCertificate not recognized
- **Cause**: Older version of SqlServer module loaded in session
- **Fix**: Installed latest SqlServer module, closed and reopened
  PowerShell to clear old module from session

## Phase 5 — SA login failed after mixed mode change
- **Phase**: VM SQL01
- **Symptom**: Login failed for user sa
- **Cause**: SQL restarted after registry change but SA not yet enabled
- **Fix**: Used sqlcmd with Windows auth (-E flag) to enable SA account
  without needing SA credentials

## Phase 6 — App Service quota limit of 0
- **Phase**: App Service
- **Symptom**: SubscriptionIsOverQuotaForSku error on deployment
- **Cause**: Free Azure account had zero quota for all App Service SKUs
  in West US including B1 and F1
- **Fix**: Requested B1 quota increase via Azure portal Quotas page,
  auto-approved within minutes

## Phase 6 — Key Vault name conflict across regions
- **Phase**: App Service
- **Symptom**: Resource kv-stephenlab already exists in location westus
  error when redeploying to eastus
- **Cause**: First deployment partially created Key Vault before failing,
  soft delete prevents immediate reuse of the name
- **Fix**: Purged the soft-deleted Key Vault and used kv-stephenlab2

## Phase 7 — AzCopy job cancelled with 0 transfers
- **Phase**: Azure Files
- **Symptom**: AzCopy job completing immediately with 0 files transferred
- **Cause**: SAS token expiry time generated in local timezone (PDT)
  instead of UTC, making token appear expired to Azure
- **Fix**: Used .ToUniversalTime() when generating expiry timestamp to
  ensure UTC time is used

## Phase 7 — AzCopy authentication failed 403
- **Phase**: Azure Files
- **Symptom**: RESPONSE 403 AuthenticationFailed — signed expiry time
  before signed start time
- **Cause**: Same timezone mismatch — token expiry in PDT was 3 hours
  behind UTC current time
- **Fix**: Generated fresh SAS token with correct UTC expiry

## Phase 8 — App Service backup not allowed in current site mode
- **Phase**: Backup
- **Symptom**: Backup/Restore feature is not allowed in current site mode
- **Cause**: App Service backup requires Standard SKU or higher.
  Lab uses B1 Basic due to free account quota constraints
- **Fix**: Documented as known limitation. In production App Service
  would run on Standard or Premium tier

## Phase 10 — GitHub Actions federated credential subject mismatch
- **Phase**: CI/CD
- **Symptom**: AADSTS700213 no matching federated identity record found
- **Cause**: Federated credential created with repo name
  homelab-azure-migration but actual repo name is Azure-Migration
- **Fix**: Deleted and recreated federated credential with correct
  repo name stephenlee91/Azure-Migration

## Phase 10 — GitHub Actions deploy job OIDC failure
- **Phase**: CI/CD
- **Symptom**: Login failed for deploy job but validate job succeeded
- **Cause**: Deploy job uses production environment which requires a
  separate federated credential for the environment subject claim
- **Fix**: Created second federated credential for
  repo:stephenlee91/Azure-Migration:environment:production and created
  production environment in GitHub repo settings

## Phase 10 — Role assignment authorization failed
- **Phase**: CI/CD
- **Symptom**: Authorization failed for Microsoft.Authorization/roleAssignments
- **Cause**: Service principal had Contributor role which cannot create
  or manage role assignments
- **Fix**: Upgraded service principal to Owner role on rg-stephenlab

## Phase 10 — Tagging policy blocking CI/CD deployment
- **Phase**: CI/CD
- **Symptom**: RequestDisallowedByPolicy on NIC and VM resources
- **Cause**: Tagging policy assigned in Phase 9 blocking resources
  without Environment tag during redeployment via CI/CD pipeline
- **Fix**: Removed tagging policy before CI/CD deployment. In production
  all resources would have tags before enabling deny policies