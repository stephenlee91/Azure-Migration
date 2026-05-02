# Phase 4 — Azure Update Manager

## Objective
Configure Azure Update Manager to assess and patch Arc-enabled 
on-premises servers from Azure.

## Prerequisites
- DC01 and APP01 connected to Azure Arc
- Azure Update Manager available in rg-stephenlab

## Steps

### 1. Ran update assessment
Selected DC01 and APP01 in Update Manager and ran Check for updates.
Both VMs returned lists of pending Windows updates.

### 2. Created maintenance configuration
- Name: maintenance-stephenlab
- Region: West US
- OS: Windows
- Scope: Guest (Arc-enabled VMs)
- Recurrence: Weekly at 2:00 AM

### 3. Assigned VMs to maintenance schedule
DC01 and APP01 added to maintenance-stephenlab configuration.

## Validation
Both VMs visible in Update Manager with pending update counts.
Maintenance schedule created and assigned.

## Screenshots
- screenshots/phase-04/update-manager-machines.png
- screenshots/phase-04/pending-updates-dc01.png
- screenshots/phase-04/maintenance-config.png

## Time taken
~20 minutes

## References
- https://learn.microsoft.com/azure/update-manager/overview