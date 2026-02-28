# Backend configuration is supplied at runtime via -backend-config=backend.hcl
# Generated from tf_infra/backend.conf.tpl by the CI/CD pipeline or bootstrap script.
# Never edit this file directly — edit backend.conf.tpl instead.
terraform {
  backend "azurerm" {}
}
