<#
.SYNOPSIS
    Bootstraps the Azure remote state backend for a Terraform project.

.DESCRIPTION
    Creates the resource group, storage account, and blob container used by
    the tf-infra.yml workflow to store Terraform remote state.
    Resource names are derived using the same convention as the workflow:
        Resource Group   : rg-tfstate-<ProjectName>
        Storage Account  : stgtfstate<ProjectName>001
        Container        : tfstatecontainer

.PARAMETER ProjectName
    Short project identifier (e.g. siada). Used to build resource names.

.PARAMETER Location
    Azure region for all resources. Defaults to brazilsouth.

.PARAMETER SubscriptionId
    Azure Subscription ID to deploy resources into.

.EXAMPLE
    .\New-StartupResources.ps1 -ProjectName "siada" -SubscriptionId "00000000-0000-0000-0000-000000000000"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [Parameter(Mandatory = $false)]
    [string]$Location = "brazilsouth",

    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId
)

# Derived names — must match tf-infra.yml naming convention
$rgName        = "rg-tfstate-$ProjectName"
$saName        = "stgtfstate$($ProjectName)001"
$containerName = "tfstatecontainer"
$sku           = "Standard_LRS"

# Function to check Azure login
function Invoke-AzureLoginCheck {
    Write-Host "Checking Azure login status..."
    $account = az account show 2>$null
    if ($null -eq $account) {
        Write-Host "Not logged into Azure. Please log in..."
        az login
        if ($LASTEXITCODE -ne 0) { 
            Write-Host "Failed to log in to Azure"
            exit 1 
        }
    } else {
        Write-Host "Already logged into Azure."
    }
}

# Function to set the current subscription
function Set-Subscription {
    Write-Host "Setting subscription to: $SubscriptionId..."
    az account set `
        --subscription $SubscriptionId `
        --output jsonc 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to set subscription"
        exit 1
    }
}

# Function to create a resource group
function New-ResourceGroup {
    Write-Host "Creating resource group: $rgName in $Location..."
    az group create `
        --name $rgName `
        --location $Location `
        --output jsonc 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create resource group"
        exit 1
    }
}

# Function to create a storage account
function New-StorageAccount {
    Write-Host "Creating storage account: $saName..."
    az storage account create `
        --resource-group $rgName `
        --name $saName `
        --sku $sku `
        --allow-blob-public-access false `
        --output jsonc 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create storage account"
        exit 1
    }
}

# Function to create a storage container
function New-StorageContainer {
    Write-Host "Creating storage container: $containerName..."
    az storage container create `
        --name $containerName `
        --account-name $saName `
        --output jsonc 
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create storage container"
        exit 1
    }
}

# Function to enable soft delete and versioning for blobs
function Enable-BlobSoftDeleteAndVersioning {
    Write-Host "Enabling soft delete and versioning for blobs in storage account: $saName..."
    az storage account blob-service-properties update `
        --account-name $saName `
        --enable-delete-retention true `
        --delete-retention-days 7 `
        --enable-versioning true `
        --output jsonc
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to enable soft delete and versioning for blobs"
        exit 1
    }
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
Write-Host "Configure the following in your GitHub Environment ($ProjectName / DES / TQS / PRD):"
Write-Host ""
Write-Host "  Environment Variables:"
Write-Host "    ARM_CLIENT_ID       : <service-principal-app-id>"
Write-Host "    ARM_TENANT_ID       : <azure-tenant-id>"
Write-Host "    ARM_SUBSCRIPTION_ID : $SubscriptionId"
Write-Host ""
Write-Host "  Environment Secrets:"
Write-Host "    ARM_CLIENT_SECRET   : <service-principal-client-secret>"
Write-Host ""
Write-Host "  Terraform backend resources created:"
Write-Host "    Resource Group      : $rgName"
Write-Host "    Storage Account     : $saName"
Write-Host "    Container           : $containerName"
