# ─────────────────────────────────────────────────────────────────────────────
# Terraform Backend Configuration Template
#
# This is the SINGLE SOURCE OF TRUTH for remote state resource naming.
# Rendered at runtime by scripts/New-StartupResources.ps1 (bootstrap) and
# .github/workflows/tf-infra.yml (CI/CD) into backend.hcl — never committed.
#
# Placeholders:
#   ${project}      — short project name  (e.g. siada)
#   ${environment}  — environment name    (e.g. des, prd)
#   ${subscription} — Azure Subscription ID
#
# Naming convention:
#   Resource Group   : rg-tfstate-${project}
#   Storage Account  : stgtfstate${project}
#   Container        : tfstatecontainer
#   State Key        : ${environment}-${project}-infra.tfstate
# ─────────────────────────────────────────────────────────────────────────────

resource_group_name  = "rg-tfstate-${project}"
storage_account_name = "stgtfstate${project}"
container_name       = "tfstatecontainer"
key                  = "${environment}-${project}-infra.tfstate"
subscription_id      = "${subscription}"
