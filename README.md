# labaks — Azure Infrastructure with Terraform & GitHub Actions

This repository provisions Azure infrastructure (AKS, Event Hub, Redis, VNet, Storage, Log Analytics) using Terraform modules deployed via a GitHub Actions workflow with `workflow_dispatch`.

---

## Repository Structure

```
.github/
  workflows/
    tf-infra.yml          # Main CI/CD workflow
scripts/
  New-StartupResources.ps1  # Bootstraps remote state backend (run once per project)
  Set-TfEnvVars.ps1         # Local helper to set TF env vars for manual runs
tf_infra/
  main.tf                   # Root module — wires all child modules
  variables.tf
  backend.tf                # Backend config with token placeholders
  provider.tf
  modules/                  # Reusable Terraform modules
    aks/
    eventhub/
    eventhubnamespace/
    loganalytics/
    redis/
    resourcegroup/
    storageaccount/
    subnet/
    vnet/
  tfvars/
    des.tfvars              # Development/test environment
    tqs.tfvars              # QA/staging environment
    prd.tfvars              # Production environment
```

---

## Prerequisites

| Tool | Version |
|------|---------|
| [Terraform](https://developer.hashicorp.com/terraform/install) | >= 1.7.5 |
| [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) | latest |
| [PowerShell](https://learn.microsoft.com/powershell/scripting/install/installing-powershell) | >= 7 |

You also need:
- An Azure **Service Principal** with `Contributor` on the target subscription
- A **GitHub repository** with Actions enabled
- [Infracost](https://www.infracost.io/) API key (for cost estimation on `tqs`/`prd`)

---

## 1. Bootstrap — Create Remote State Backend

Run this **once per project** before using the workflow. It creates the resource group, storage account, and blob container that Terraform uses to store remote state.

```powershell
.\scripts\New-StartupResources.ps1 `
    -ProjectName   "siada" `
    -SubscriptionId "00000000-0000-0000-0000-000000000000" `
    -Location      "brazilsouth"   # optional, defaults to brazilsouth
```

This creates:

| Resource | Name pattern |
|----------|-------------|
| Resource Group | `rg-tfstate-<ProjectName>` |
| Storage Account | `stgtfstate<ProjectName>001` |
| Blob Container | `tfstatecontainer` |

These names are hardcoded into the workflow's `env` block and must not be changed independently.

---

## 2. GitHub Environment Configuration

The workflow reads credentials from **GitHub Environment** scoped variables and secrets. Create one environment per deployment target (e.g. `DES`, `TQS`, `PRD`) in **Settings → Environments**.

### Environment Variables (`vars.*`)

| Variable | Description |
|----------|-------------|
| `ARM_CLIENT_ID` | Service Principal Application (client) ID |
| `ARM_TENANT_ID` | Azure Active Directory Tenant ID |
| `ARM_SUBSCRIPTION_ID` | Target Azure Subscription ID |

### Environment Secrets (`secrets.*`)

| Secret | Description |
|--------|-------------|
| `ARM_CLIENT_SECRET` | Service Principal client secret |
| `INFRACOST_API_KEY` | Infracost API key *(only required on `tqs`/`prd`)* |

> **Why Environment-scoped and not repository secrets?**  
> Each environment (`DES`, `TQS`, `PRD`) authenticates to a different Azure subscription or service principal. Environment-scoped values ensure the right credentials are used per target, and allow protection rules (e.g. required reviewers before `apply` on `PRD`).

---

## 3. Workflow — `tf-infra.yml`

Triggered manually via **Actions → Terraform Infrastructure → Run workflow**.

### Inputs

| Input | Options | Default | Description |
|-------|---------|---------|-------------|
| `action` | see below | `plan` | Operation to run |
| `project` | string | `siada` | Project name — used to build backend resource names |
| `environment` | `des` / `tqs` / `prd` | `des` | Target environment |
| `tf_loglevel` | `INFO` / `WARN` / `ERROR` / `DEBUG` | `INFO` | Terraform log verbosity |

### Actions

| Action | Description | Best for |
|--------|-------------|----------|
| `validate` | `terraform validate` only | Quick syntax check |
| `checkov` | Validate + Checkov security scan | Security review |
| `plan` | Validate → Checkov (parallel) → Plan + Infracost | Pre-apply review on `tqs`/`prd` |
| `apply` | Plan → manual artifact review → Apply | Controlled `tqs`/`prd` deploys |
| `plan_apply` | Validate → Plan → Apply in one job | **Fast iteration on `des`** |
| `plan_destroy` | Plan a destroy | Preview teardown |
| `apply_destroy` | Plan destroy → Apply destroy | Teardown environment |

### Job Dependency Graph

```
workflow_dispatch
       │
  [validate] ──┬──► [plan] ──────────────────────────► [apply]
               │     └─ Infracost skipped on des
               │
               ├──► [plan_apply]  ◄── fast DES loop
               │
               ├──► [plan_destroy] ──────────────────► [apply_destroy]
               │
               └──► [checkov]  ◄── parallel, non-blocking
```

> Checkov runs in parallel and **never blocks** plan or apply — failures are informational only.  
> Infracost runs only on `tqs` and `prd` to avoid noise during module development on `des`.

### Concurrency

Only one run per `project + environment` combination can be active at a time. New runs queue behind the in-flight run (they do not cancel it).

---

## 4. Module Testing Loop (DES)

When developing or modifying Terraform modules, use this loop against the `des` environment:

```
1. Edit module code / tfvars/des.tfvars
2. git push
3. Actions → Run workflow → action: plan_apply, environment: des
   └─ Validate → Init → Workspace → Plan → Apply  (single job, ~2-3 min)
4. Verify resources in Azure Portal
5. Repeat 1–4 as needed
6. Actions → Run workflow → action: apply_destroy, environment: des
   └─ Tear down when done
```

For a safe preview before applying:

```
1. Actions → Run workflow → action: plan, environment: des
   └─ Review plan output in job logs
2. Actions → Run workflow → action: apply, environment: des
   └─ Downloads plan artifact and applies it
```

---

## 5. Terraform Modules

| Module | Description |
|--------|-------------|
| `aks` | Azure Kubernetes Service cluster with Log Analytics integration |
| `eventhubnamespace` | Event Hub Namespace (Kafka-enabled) |
| `eventhub` | Event Hub topics within a namespace |
| `loganalytics` | Log Analytics Workspace with solutions |
| `redis` | Azure Cache for Redis |
| `resourcegroup` | Resource Group |
| `storageaccount` | Storage Account with file share and blob container |
| `subnet` | Subnet with NSG and security rules |
| `vnet` | Virtual Network |

Each module has an `enable_module_<name>` boolean flag in `variables.tf` so individual modules can be toggled on/off without removing them from the configuration.

---

## 6. Terraform State

State is stored remotely in Azure Blob Storage, isolated per environment and project:

```
Storage Account : stgtfstate<project>001
Container       : tfstatecontainer
State file key  : <environment>-<project>-infra.tfstate
```

Blob versioning and soft-delete (7 days) are enabled by `New-StartupResources.ps1`.

---

## 7. Backend Token Replacement

`backend.tf` uses placeholder tokens that are substituted at runtime by the workflow using [cschleiden/replace-tokens](https://github.com/cschleiden/replace-tokens):

```hcl
# backend.tf (before substitution)
resource_group_name  = "__BackendAzureRmResourceGroupName__"
storage_account_name = "__BackendAzureRmStorageAccountName__"
container_name       = "__BackendAzureRmContainerName__"
key                  = "__BackendAzureRmKey__"
```

Do not commit a backend.tf with real values — always use the `__token__` placeholders.
