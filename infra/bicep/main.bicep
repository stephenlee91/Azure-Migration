// main.bicep — Phase 10
// Orchestrates all modules in a single deployment
targetScope = 'resourceGroup'

param location string = resourceGroup().location

@secure()
param sqlAdminPassword string

param subnetId string

// Phase 2 — Networking
module networking 'modules/vnet.bicep' = {
  name: 'networking'
  params: {
    location: location
  }
}

// Phase 5 — SQL VM
module sqlVm 'modules/sql-vm.bicep' = {
  name: 'sqlVm'
  params: {
    location: location
    adminPassword: sqlAdminPassword
    subnetId: subnetId
  }
  dependsOn: [networking]
}

// Phase 6 — App Service + Key Vault
module appService 'modules/app-service.bicep' = {
  name: 'appService'
  params: {
    location: location
  }
  dependsOn: [networking]
}

// Phase 7 — Storage + Azure Files
module storage 'modules/storage.bicep' = {
  name: 'storage'
  params: {
    location: location
  }
}

// Phase 8 — Recovery Vault
module backup 'modules/recovery-vault.bicep' = {
  name: 'backup'
  params: {
    location: location
  }
}

// Phase 9 — Monitoring
module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
  }
  dependsOn: [appService]
}