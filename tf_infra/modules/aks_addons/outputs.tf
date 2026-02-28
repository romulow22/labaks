output "akv2k8s_release_status" {
  value       = helm_release.akv2k8s.status
  description = "Helm release status of akv2k8s"
}

output "akv2k8s_namespace" {
  value       = helm_release.akv2k8s.namespace
  description = "Kubernetes namespace where akv2k8s is deployed"
}
