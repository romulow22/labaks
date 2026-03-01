# ─────────────────────────────────────────────────────────────────────────────
# Terraform Backend Configuration Template
#
# This is the SINGLE SOURCE OF TRUTH for remote state resource naming.
# Rendered at runtime by scripts/New-StartupResources.ps1 (bootstrap) and
# .github/workflows/tf-infra.yml (CI/CD) into backend.hcl — never committed.
#
# Placeholders:
#   ${project}      — short project name  (e.g. siada)
#   ${environment}  — environment name    (e.g. des, tqs, prd)
#   ${subscription} — Azure Subscription ID
#
# Naming convention:
#   Resource Group   : rg-tfstate-${project}
#   Storage Account  : stgtfstate${project}
#   Container        : tfstatecontainer
#   State Key        : ${environment}-${project}-infra.tfstate
#
# use_azuread_auth = true enables Entra ID (OIDC) auth for the backend so
# no storage account key is required — the pipeline's federated identity
# must have "Storage Blob Data Contributor" on the state container.
# ─────────────────────────────────────────────────────────────────────────────

resource_group_name  = "rg-tfstate-${project}"
storage_account_name = "stgtfstate${project}"
container_name       = "tfstatecontainer"
key                  = "${environment}-${project}-infra.tfstate"
subscription_id      = "${subscription}"
use_azuread_auth     = true
use_oidc             = true
