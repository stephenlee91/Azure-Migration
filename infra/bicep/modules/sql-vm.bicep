// sql-vm.bicep — Phase 5 SQL Server VM
param location string = resourceGroup().location
param vmName string = 'VM-SQL01'
param adminUsername string = 'sqladmin'
@secure()
param adminPassword string
param subnetId string

// Network interface
resource nic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: 'nic-${vmName}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: subnetId }
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.1.10'
        }
      }
    ]
  }
}

// SQL Server VM
resource vm 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: { vmSize: 'Standard_D2s_v3' }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: false
        patchSettings: { patchMode: 'Manual' }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftSQLServer'
        offer: 'sql2022-ws2022'
        sku: 'sqldev-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'Premium_LRS' }
        diskSizeGB: 128
      }
      dataDisks: [
        {
          lun: 0
          name: 'disk-${vmName}-data'
          createOption: 'Empty'
          diskSizeGB: 64
          managedDisk: { storageAccountType: 'Premium_LRS' }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [{ id: nic.id }]
    }
  }
}

output vmId string = vm.id
output privateIp string = nic.properties.ipConfigurations[0].properties.privateIPAddress