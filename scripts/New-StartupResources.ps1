<#
.SYNOPSIS
    Bootstraps the Azure remote state backend for a Terraform project.

.DESCRIPTION
    Creates the resource group, storage account, and blob container used by
    the tf-infra.yml workflow to store Terraform remote state.

    Resource names are derived from tf_infra/backend.conf.tpl — the single
    source of truth for backend naming convention. No names are hardcoded here.

.PARAMETER ProjectName
    Short project identifier (e.g. siada).

.PARAMETER SubscriptionId
    Azure Subscription ID to deploy resources into.

.PARAMETER Location
    Azure region for all resources. Defaults to brazilsouth.

.EXAMPLE
    .\New-StartupResources.ps1 -ProjectName "siada" -SubscriptionId "00000000-0000-0000-0000-000000000000"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $false)]
    [string]$Location = "brazilsouth"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────────────────────────────────────
# Resolve names from backend.conf.tpl — single source of truth
# ─────────────────────────────────────────────────────────────────────────────
$scriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Path
$templatePath = Resolve-Path (Join-Path $scriptDir "..\tf_infra\backend.conf.tpl")

if (-not (Test-Path $templatePath)) {
    Write-Error "Template not found: $templatePath"
    exit 1
}

# Substitute placeholders in the template content
$content = Get-Content $templatePath -Raw
$content = $content `
    -replace '\$\{project\}',      $ProjectName `
    -replace '\$\{environment\}',  'bootstrap' `
    -replace '\$\{subscription\}', $SubscriptionId

# Parse a quoted HCL value by key name
function Get-HclValue {
    param([string]$Content, [string]$Key)
    if ($Content -match "(?m)^$Key\s*=\s*`"([^`"]+)`"") {
        return $Matches[1]
    }
    Write-Error "Could not parse '$Key' from backend.conf.tpl"
    exit 1
}

$rgName        = Get-HclValue -Content $content -Key "resource_group_name"
$saName        = Get-HclValue -Content $content -Key "storage_account_name"
$containerName = Get-HclValue -Content $content -Key "container_name"
$sku           = "Standard_LRS"

Write-Host ""
Write-Host "Bootstrap configuration (derived from tf_infra/backend.conf.tpl):" -ForegroundColor Cyan
Write-Host "  Resource Group   : $rgName"
Write-Host "  Storage Account  : $saName"
Write-Host "  Container        : $containerName"
Write-Host "  Location         : $Location"
Write-Host "  Subscription     : $SubscriptionId"
Write-Host ""

# ─────────────────────────────────────────────────────────────────────────────
# Azure helpers
# ─────────────────────────────────────────────────────────────────────────────
function Invoke-AzureLoginCheck {
    Write-Host "Checking Azure login status..."
    $account = az account show 2>$null
    if ($null -eq $account) {
        Write-Host "Not logged in — running az login..."
        az login
        if ($LASTEXITCODE -ne 0) { Write-Error "az login failed"; exit 1 }
    }
    else {
        Write-Host "Already logged in."
    }
}

function Set-Subscription {
    Write-Host "Setting subscription to: $SubscriptionId..."
    az account set --subscription $SubscriptionId
    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to set subscription"; exit 1 }
}

function New-ResourceGroup {
    Write-Host "Creating resource group: $rgName..."
    az group create --name $rgName --location $Location | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to create resource group"; exit 1 }
}

function New-StorageAccount {
    Write-Host "Creating storage account: $saName..."
    az storage account create `
        --name $saName `
        --resource-group $rgName `
        --location $Location `
        --sku $sku `
        --kind StorageV2 `
        --https-only true `
        --min-tls-version TLS1_2 `
        --allow-blob-public-access false | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to create storage account"; exit 1 }
}

function Enable-BlobSoftDeleteAndVersioning {
    Write-Host "Enabling blob versioning and soft delete..."
    az storage account blob-service-properties update `
        --account-name $saName `
        --resource-group $rgName `
        --enable-versioning true `
        --enable-delete-retention true `
        --delete-retention-days 7 | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to enable blob properties"; exit 1 }
}

function New-StorageContainer {
    Write-Host "Creating blob container: $containerName..."
    az storage container create `
        --name $containerName `
        --account-name $saName `
        --auth-mode login | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to create container"; exit 1 }
}

# ─────────────────────────────────────────────────────────────────────────────
# Run
# ─────────────────────────────────────────────────────────────────────────────
Invoke-AzureLoginCheck
Set-Subscription
New-ResourceGroup
New-StorageAccount
Enable-BlobSoftDeleteAndVersioning
New-StorageContainer

Write-Host ""
Write-Host "Bootstrap complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Configure the following in your GitHub Environments (des / prd):" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Variables:"
Write-Host "    ARM_CLIENT_ID       : <service-principal-app-id>"
Write-Host "    ARM_TENANT_ID       : <azure-tenant-id>"
Write-Host "    ARM_SUBSCRIPTION_ID : $SubscriptionId"
Write-Host ""
Write-Host "  Secrets:"
Write-Host "    ARM_CLIENT_SECRET   : <service-principal-client-secret>"
Write-Host ""
Write-Host "  Terraform remote state resources:"
Write-Host "    Resource Group      : $rgName"
Write-Host "    Storage Account     : $saName"
Write-Host "    Container           : $containerName"
