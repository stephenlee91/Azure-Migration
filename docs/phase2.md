# Phase 2 — Networking (VNet · Bastion · NSG)

## Objective
Deploy the Azure networking foundation using Bicep — VNet, subnets, 
NSG, and Azure Bastion for secure VM access without public IPs.

## Prerequisites
- Azure resource group rg-stephenlab exists
- Azure CLI and Bicep installed on host machine

## Resources deployed

| Resource              | Value              |
|-----------------------|--------------------|
| VNet                  | vnet-stephenlab    |
| Address space         | 10.0.0.0/16        |
| Subnet servers        | 10.0.1.0/24        |
| Subnet app service    | 10.0.2.0/24        |
| Subnet bastion        | 10.0.3.0/26        |
| NSG                   | nsg-stephenlab     |
| Bastion               | bastion-stephenlab |
| Bastion SKU           | Developer          |
| Location              | West US            |

## Deployment

```powershell
az deployment group create
  --resource-group rg-stephenlab
  --template-file infra/bicep/modules/vnet.bicep
  --verbose
```

## Validation

```powershell
az network vnet show
  --resource-group rg-stephenlab
  --name vnet-stephenlab
  --query "{name:name, addressSpace:addressSpace.addressPrefixes}"
  --output table

az network bastion show
  --resource-group rg-stephenlab
  --name bastion-stephenlab
  --query "{name:name, sku:sku.name, provisioningState:provisioningState}"
  --output table
```

## NSG rules

| Rule                  | Priority | Direction | Port | Action |
|-----------------------|----------|-----------|------|--------|
| Allow-RDP-Bastion     | 100      | Inbound   | 3389 | Allow  |
| Allow-HTTPS-Inbound   | 110      | Inbound   | 443  | Allow  |
| Allow-HTTP-Inbound    | 120      | Inbound   | 80   | Allow  |

## Screenshots
- screenshots/phase-02/vnet-overview.png
- screenshots/phase-02/bastion-deployed.png
- screenshots/phase-02/nsg-rules.png

## Time taken
~30 minutes

## References
- https://learn.microsoft.com/azure/bastion/bastion-overview
- https://learn.microsoft.com/azure/virtual-network/virtual-networks-overview
