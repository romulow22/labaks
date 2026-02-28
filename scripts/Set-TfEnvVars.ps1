# Set environment variables for AzureRM provider (local dev only — never commit real values)
$env:ARM_CLIENT_ID       = "<your-client-id>"
$env:ARM_CLIENT_SECRET   = "<your-client-secret>"
$env:ARM_TENANT_ID       = "<your-tenant-id>"
$env:ARM_SUBSCRIPTION_ID = "<your-subscription-id>"

Write-Output "ARM_CLIENT_ID=$env:ARM_CLIENT_ID"
Write-Output "ARM_TENANT_ID=$env:ARM_TENANT_ID"
Write-Output "ARM_SUBSCRIPTION_ID=$env:ARM_SUBSCRIPTION_ID"
Write-Output "ARM_CLIENT_SECRET=***"