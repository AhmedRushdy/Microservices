output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The URL of the ACR login server"
}

output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "The name of the Azure Container Registry"
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.k8s.name
  description = "The name of the AKS cluster"
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}