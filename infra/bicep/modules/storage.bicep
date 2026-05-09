// storage.bicep — Phase 7
param location string = resourceGroup().location
param storageAccountName string = 'stfilesdaniellab'

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    largeFileSharesState: 'Disabled'
  }
}

// File Share
resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  name: '${storageAccount.name}/default/labshare'
  properties: {
    shareQuota: 5
  }
}

// Outputs
output storageAccountName string = storageAccount.name
output fileShareName string = 'labshare'