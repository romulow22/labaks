#  akv2k8s (Azure Key Vault to Kubernetes) 
# Syncs Key Vault secrets/certs into K8s secrets; injects them into pods via env
resource "helm_release" "akv2k8s" {
  name             = "akv2k8s"
  repository       = "https://charts.spvapi.no"
  chart            = "akv2k8s"
  namespace        = "akv2k8s"
  create_namespace = true
  version          = "2.5.3"
  cleanup_on_fail  = true
  atomic           = true
  timeout          = 300

  set = [
    {
      name  = "global.logLevel"
      value = var.environment == "des" ? "debug" : "info"
    },
    {
      name  = "global.logFormat"
      value = "json"
    },
    {
      name  = "controller.enabled"
      value = "true"
    },
    {
      name  = "controller.podLabels.azure\\.workload\\.identity/use"
      value = "true"
    },
    {
      name  = "env_injector.enabled"
      value = "true"
    },
    {
      name  = "global.keyVaultAuth"
      value = "azureWorkloadIdentity"
    },
    {
      name  = "global.azureWorkloadIdentity.clientId"
      value = var.aks_identity_client_id
    },
  ]
  depends_on = [var.aks_cluster_id]
}