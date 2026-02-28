# AKS Lab Infrastructure

A production-ready **Azure Kubernetes Service (AKS)** platform fully provisioned with **Terraform** and automated via **GitHub Actions**. The repository contains modular infrastructure-as-code (IaC) and an example Kubernetes workload with Istio service mesh.

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── tf-infra.yml           # Terraform CI/CD pipeline
├── apps/
│   └── exampleapp.yaml            # Example app with Istio (Gateway, VirtualService)
├── scripts/
│   ├── New-StartupResources.ps1   # Bootstrap Terraform remote state backend
│   └── Set-TfEnvVars.ps1          # Set ARM env vars for local dev
├── tf_infra/
│   ├── main.tf                    # Root module wiring all sub-modules
│   ├── variables.tf               # Root-level variable declarations
│   ├── backend.tf                 # Empty partial config — filled at runtime
│   ├── backend.conf.tpl           # Single source of truth for backend naming
│   ├── provider.tf                # AzureRM provider configuration
│   ├── tfvars/
│   │   ├── des.tfvars             # Development environment values
│   │   └── prd.tfvars             # Production environment values (tokenized)
│   └── modules/
│       ├── acr/                   # Azure Container Registry
│       ├── aks/                   # AKS orchestrator (cluster + ACR + monitoring + addons)
│       ├── aks_cluster/           # AKS cluster resource
│       ├── aks_addons/            # Helm-based addons (akv2k8s, Istio)
│       ├── aks_monitoring/        # Data Collection Rules for Container Insights
│       ├── bastion/               # Azure Bastion
│       ├── jumpervm/              # Jumper VM (private kubectl access via Bastion)
│       ├── keyvault/              # Azure Key Vault
│       ├── loganalytics/          # Log Analytics Workspaces
│       ├── resourcegroup/         # Resource Groups
│       ├── storageaccount/        # Storage Account (blob + file share)
│       ├── subnet/                # Subnets + NSGs
│       └── vnet/                  # Virtual Network
└── README.md
```

---

## Architecture Overview

```
┌────────────────────────────────────────────────────────────────────┐
│                        Azure Subscription                          │
│                                                                    │
│  ┌─────────────────┐  ┌─────────────────┐  ┌───────────────────┐  │
│  │  rg-vnet-*      │  │  rg-aks-*       │  │  rg-resources-*   │  │
│  │                 │  │                 │  │                   │  │
│  │  VNet           │  │  AKS Cluster    │  │  Storage Account  │  │
│  │  10.0.0.0/16    │  │  ├─ Sys Pool    │  │  Key Vault        │  │
│  │  ├─ AKS Subnet  │  │  └─ Wrk Pool    │  │  Jumper VM        │  │
│  │  │  10.0.1.0/24 │  │                 │  │  Log Analytics    │  │
│  │  ├─ Pvt Subnet  │  │  ACR            │  │                   │  │
│  │  │  10.0.2.0/24 │  │  Monitoring     │  │                   │  │
│  │  └─ Bastion     │  │  (Container     │  │                   │  │
│  │     Subnet      │  │   Insights)     │  │                   │  │
│  └─────────────────┘  └─────────────────┘  └───────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```

### Key Components

| Component | Description |
|-----------|-------------|
| **VNet** | `10.0.0.0/16` with dedicated AKS (`10.0.1.0/24`) and private (`10.0.2.0/24`) subnets |
| **AKS** | Managed Kubernetes cluster with system + worker node pools, autoscaling, Workload Identity, OIDC, AzureLinux OS, and automated maintenance windows |
| **ACR** | Azure Container Registry with `AcrPull` role assigned to the AKS managed identity; zone redundancy, untagged-image retention, and quarantine policy on Premium SKU |
| **Istio** | AKS managed Istio add-on (revision `asm-1-28`) for mTLS, traffic management, and observability |
| **akv2k8s** | Syncs Azure Key Vault secrets into Kubernetes secrets via Workload Identity + OIDC |
| **Bastion** | Secure browser-based SSH/RDP without public IPs on VMs |
| **Jumper VM** | Linux VM (Ubuntu 24.04 LTS) in the private subnet for `kubectl` access through Bastion |
| **Key Vault** | Stores the Jumper VM password; accessed via RBAC |
| **Log Analytics** | Two workspaces — one for AKS (Container Insights), one for general resources |
| **Storage Account** | StorageV2 with blob container and file share |

---

## Getting Started

### Prerequisites

- Azure CLI (`az`)
- Terraform `>=1.11.0`
- PowerShell 7+
- GitHub repository with Actions enabled

### 1. Bootstrap the Remote State Backend

Run once per project to create the storage account used by Terraform remote state:

```powershell
.\scripts\New-StartupResources.ps1 `
  -ProjectName "myproject" `
  -SubscriptionId "00000000-0000-0000-0000-000000000000"
```

This creates the following resources (default region: `brazilsouth`). Names follow the convention defined in `tf_infra/backend.conf.tpl`:

| Resource | Name |
|----------|------|
| Resource Group | `rg-tfstate-<ProjectName>` |
| Storage Account | `stgtfstate<ProjectName>` |
| Blob Container | `tfstatecontainer` |

### 2. Configure GitHub Environments

Create two GitHub Environments named `des` and `prd` and populate the following variables and secrets.

**Variables:**

| Name | Description |
|------|-------------|
| `ARM_CLIENT_ID` | Service Principal App ID |
| `ARM_TENANT_ID` | Azure Tenant ID |
| `ARM_SUBSCRIPTION_ID` | Azure Subscription ID |

**Secrets:**

| Name | Description |
|------|-------------|
| `ARM_CLIENT_SECRET` | Service Principal secret |

### 3. Local Development

Set ARM environment variables for local Terraform runs:

```powershell
.\scripts\Set-TfEnvVars.ps1
```

> **Warning:** Never commit real credentials. This script is for local development only and sets in-session environment variables.

Generate `backend.hcl` from the template, then init and plan:

```powershell
cd tf_infra

# Render backend.hcl (gitignored — never committed)
(Get-Content backend.conf.tpl -Raw) `
  -replace '\$\{project\}',      'myproject' `
  -replace '\$\{environment\}',  'des' `
  -replace '\$\{subscription\}', $env:ARM_SUBSCRIPTION_ID `
  | Set-Content backend.hcl

terraform init -reconfigure -backend-config=backend.hcl
terraform workspace select -or-create=true des
terraform plan -var-file="tfvars/des.tfvars"
```

---

## CI/CD Pipeline

### Terraform Infrastructure (`tf-infra.yml`)

Triggered manually via `workflow_dispatch` with the following inputs:

| Input | Options | Description |
|-------|---------|-------------|
| `action` | `validate`, `plan`, `apply`, `plan_apply`, `plan_destroy`, `apply_destroy` | Terraform operation |
| `project` | string | Short project name (e.g. `siada`) |
| `environment` | `des`, `prd` | Target environment |
| `tf_loglevel` | `INFO`, `ERROR`, `WARN`, `DEBUG` | Terraform log verbosity |

**Job Flow:**

```
terraform_validate
       │
       ├──► terraform_plan ──────────► terraform_apply
       │
       ├──► terraform_plan_apply      (combined plan+apply)
       │
       └──► terraform_plan_destroy ──► terraform_apply_destroy
```

**Pipeline highlights:**

- **`backend.conf.tpl` → `backend.hcl`** — each job renders the template with `sed` using `inputs.project`, `inputs.environment`, and `ARM_SUBSCRIPTION_ID`. `backend.hcl` is gitignored and never committed. This is the single source of truth for all backend resource naming.
- **Token replacement** (`cschleiden/replace-tokens`) injects `subscription_id`, `project_name`, and `env` into `.tfvars` files only — `backend.tf` is no longer touched.
- **TFLint** runs on every execution for static analysis.
- **Infracost** (currency: BRL) generates a cost estimate during plan for non-`des` environments.
- **Terraform Workspaces** isolate state per environment (`des`, `prd`).
- Plan artifacts are uploaded and retained for 5 days.
- Concurrent runs for the same project+environment are blocked (`cancel-in-progress: false`).

---

## Terraform Modules

Each module is independently toggleable via a `enable_module_*` boolean variable defined in `variables.tf`.

### `modules/resourcegroup`
Creates Azure Resource Groups. Naming convention: `rg-<service>-<project>-<env>`.

Three groups are provisioned by default: `vnet`, `aks`, and `resources`.

### `modules/vnet`
Creates a Virtual Network (`10.0.0.0/16`) with configurable address space and VNet-level traffic encryption (`AllowUnencrypted` enforcement — enables encrypted inter-VM traffic for compatible VM SKUs).

### `modules/subnet`
Creates subnets with associated NSGs and dynamically injected security rules. Two subnets are provisioned:
- `aks` (`10.0.1.0/24`) — allows inbound HTTP/HTTPS
- `pvt` (`10.0.2.0/24`) — allows inbound VNet-to-VNet traffic only

### `modules/acr`
Creates an Azure Container Registry and assigns the `AcrPull` role to the AKS cluster's managed identity. Additional hardening is applied based on SKU:

| Feature | Basic | Standard | Premium |
|---------|-------|----------|---------|
| Zone redundancy | — | — | ✓ |
| Untagged image retention | — | 7 days | 7 days |
| Quarantine policy | — | — | ✓ |

### `modules/aks`
Orchestrator module that composes:
- `aks_cluster` — AKS cluster with system node pool, autoscaler, Workload Identity, and OIDC
- `aks_monitoring` — Data Collection Rules for Container Insights
- `aks_addons` — Helm releases deployed post-cluster creation

### `modules/aks_cluster`
Core AKS cluster resource:
- System node pool (`sysnodepool`) on VMSS with autoscaling and `os_sku = "AzureLinux"`
- Separate worker node pool with configurable VM size
- User-assigned managed identity
- **Workload Identity** (`workload_identity_enabled = true`) + **OIDC Issuer** (`oidc_issuer_enabled = true`) — required for pod-level Azure auth (akv2k8s)
- `automatic_upgrade_channel` and `node_os_upgrade_channel` (defaults: `patch` / `SecurityPatch`)
- Image cleaner to purge unused container images from nodes on a configurable interval (default: 48 h)
- `max_surge = "33%"` on both system and worker node pools for faster rolling upgrades
- Scheduled maintenance windows: control-plane upgrades Sunday 02:00 UTC-3; node OS updates Sunday 03:00 UTC-3
- Integrated Log Analytics for Container Insights

### `modules/aks_addons`
Helm releases deployed to the cluster after provisioning:
- **akv2k8s** (`v2.5.3`) — Key Vault to Kubernetes secret sync using Workload Identity
- Debug-level logging in `des`; info-level in `prd`

### `modules/aks_monitoring`
Creates Azure Monitor Data Collection Rules and associates them with the AKS cluster for Container Insights telemetry.

### `modules/keyvault`
Azure Key Vault with:
- RBAC authorization (not legacy access policies)
- Configurable soft-delete retention (7–90 days)
- `purge_protection_enabled = false` for non-production (enables `terraform destroy`)

### `modules/jumpervm`
Linux VM (Ubuntu 24.04 LTS) in the private subnet for secure cluster administration:
- **Spot instance** in `des` to reduce costs
- User-assigned identity with `Azure Kubernetes Service RBAC Cluster Admin` + `Cluster User` roles
- Password randomly generated and stored in Key Vault (`jumper-vm-password` secret)
- Cloud-init script installs: Azure CLI, `kubectl`, Helm

### `modules/bastion`
Azure Bastion in a dedicated `/26` subnet. Standard SKU supports native client tunneling for `kubectl` proxying.

### `modules/loganalytics`
Creates Log Analytics workspaces (SKU: `PerGB2018`). Two workspaces are provisioned:
- `aks` — Container Insights solution, 30-day retention
- `resources` — General resource logs, 30-day retention

`local_authentication_disabled = true` is set on all workspaces — workspace key auth is disabled and all queries must use Entra ID identities.

### `modules/storageaccount`
Storage Account (StorageV2) with:
- Blob versioning + soft-delete (7 days for blobs and containers)
- TLS 1.2 enforced; HTTPS-only enabled
- `allow_nested_items_to_be_public = false`
- `local_user_enabled = false` and `sftp_enabled = false` — SFTP surface disabled, prefer Entra ID auth
- Diagnostic logs forwarded to the `resources` Log Analytics workspace
- Configurable blob container and file share

---

## Environments

| Environment | Key Differences |
|-------------|-----------------|
| `des` | Spot VMs for Jumper, debug-level Terraform + addon logging, Infracost skipped |
| `prd` | Standard VMs, info-level logging, Infracost cost breakdown enabled (BRL) |

---

## Sample Application

[`apps/exampleapp.yaml`](apps/exampleapp.yaml) deploys an AKS Hello World app fully integrated with Istio:

- **Namespace** labeled with `istio.io/rev: asm-1-28` for managed Istio sidecar injection
- **Deployment** using `mcr.microsoft.com/azuredocs/aks-helloworld:v1` with Envoy sidecar, resource limits, and probes
- **Service** (ClusterIP) with a named port for Istio protocol detection
- **Gateway** bound to `myapplabaks.com`
- **VirtualService** for L7 routing via Istio ingress gateway

Apply with:

```bash
kubectl apply -f apps/exampleapp.yaml
```

---

## Security Considerations

- All VMs reside in private subnets; access is only possible via Azure Bastion
- Public blob access is disabled on all storage accounts
- TLS 1.2 minimum enforced on storage accounts; HTTPS-only traffic
- Storage Account local users and SFTP are disabled
- Key Vault uses RBAC (not legacy access policies)
- AKS uses Workload Identity + OIDC for pod-level Azure authentication (no static credentials)
- AKS node OS uses AzureLinux — smaller attack surface, faster CVE patching
- AKS node OS updates follow `SecurityPatch` channel; control-plane follows `patch` channel
- Maintenance windows restrict upgrades to Sunday off-hours (UTC-3) to reduce blast radius
- Log Analytics workspaces require Entra ID authentication (`local_authentication_disabled = true`)
- VNet encryption enforcement enabled on all virtual networks
- ACR quarantine policy (Premium SKU) prevents unscanned images from being pulled
- NSGs restrict inbound/outbound traffic per subnet
- Jumper VM password is randomly generated and stored in Key Vault
- No secrets or credentials are stored in source code — backend config rendered at runtime from `backend.conf.tpl`; `backend.hcl` is gitignored

---

## Requirements

| Tool | Version |
|------|---------|
| Terraform | `>=1.11.0` |
| AzureRM Provider | `~>4.14` |
| Helm Provider | `~>2.17` |
| TLS Provider | `~>4.0` |
| Random Provider | `~>3.7` |
| Local Provider | `~>2.5` |
| Azure CLI | Latest |
| PowerShell | `7+` |
