# Phase 7 — File Server to Azure Files (AzCopy)

## Objective
Migrate the on-premises SMB file share from APP01 to Azure Files
using AzCopy.

## Prerequisites
- APP01 running with LabShare SMB share and 10 sample files
- Azure Storage Account deployed

## Resources deployed

| Resource          | Value              |
|-------------------|--------------------|
| Storage Account   | stfilesdaniellab   |
| Redundancy        | LRS                |
| File Share        | labshare           |
| Quota             | 5 GB               |

## Steps

### 1. Deployed storage via Bicep
\`\`\`powershell
az deployment group create \`
  --resource-group rg-stephenlab \`
  --template-file infra/bicep/modules/storage.bicep \`
  --verbose
\`\`\`

### 2. Downloaded AzCopy on APP01
Downloaded portable binary from Microsoft Learn and placed at
C:\AzCopy\azcopy_windows_amd64_10.32.3\azcopy.exe

### 3. Generated SAS token
\`\`\`powershell
\$expiry = (Get-Date).ToUniversalTime().AddHours(4).ToString("yyyy-MM-ddTHH:mmZ")
az storage share generate-sas \`
  --account-name stfilesdaniellab \`
  --name labshare \`
  --permissions rwdl \`
  --expiry \$expiry \`
  --output tsv
\`\`\`

### 4. Ran AzCopy migration
\`\`\`powershell
\$azcopy = "C:\AzCopy\azcopy_windows_amd64_10.32.3\azcopy.exe"
\$source = "C:\LabShare\"
\$dest = "https://stfilesdaniellab.file.core.windows.net/labshare/?SAS_TOKEN"
& \$azcopy copy \$source \$dest --recursive --log-level INFO
\`\`\`

## Result
- 10 files transferred successfully
- 0 failures
- 461 bytes transferred
- Final job status: Completed

## Issues encountered

### AzCopy job cancelled with 0 transfers
- **Cause**: SAS token expiry time was in local timezone instead of UTC
- **Fix**: Used .ToUniversalTime() when generating the expiry timestamp

### Authentication failed 403 error
- **Cause**: Signed expiry time was before signed start time due to
  timezone mismatch between host machine (PDT) and Azure (UTC)
- **Fix**: Generated new SAS token using UTC time with 4 hour window

## Screenshots
- screenshots/phase-07/azure-files-labshare.png
- screenshots/phase-07/azcopy-transfer-complete.png

## Time taken
~30 minutes

## References
- https://learn.microsoft.com/azure/storage/common/storage-use-azcopy-v10
- https://learn.microsoft.com/azure/storage/files/storage-files-introduction