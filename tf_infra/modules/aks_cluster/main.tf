resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "id-aks-${var.proj_name}-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.location

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }
}

# creating AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                 = "aks-${var.proj_name}-${var.environment}"
  location             = var.location
  resource_group_name  = var.rg_name
  dns_prefix           = "dns-aks-${var.proj_name}-${var.environment}"
  node_resource_group  = "rg-${var.proj_name}-aksnodes-${var.environment}"
  sku_tier             = var.environment == "prd" ? "Standard" : "Free"
  kubernetes_version   = var.cluster_version
  azure_policy_enabled = true

  # Workload Identity + OIDC — required for pod-level Azure auth (akv2k8s, etc.)
  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  # Automatic upgrade channels
  automatic_upgrade_channel = var.automatic_upgrade_channel
  node_os_upgrade_channel   = var.node_os_upgrade_channel

  # Periodically clean unused container images from nodes (saves disk space)
  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_interval_hours

  default_node_pool {
    name                 = "sysnodepool"
    vm_size              = var.node_vm_size
    zones                = ["1"]
    auto_scaling_enabled = true
    node_count           = 1
    max_count            = var.max_count
    min_count            = var.min_count
    vnet_subnet_id       = var.subnetaks_id
    os_disk_size_gb      = 30
    os_disk_type         = "Managed"
    os_sku               = "AzureLinux"
    type                 = "VirtualMachineScaleSets"

    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
      "role"          = "agent"
    }

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "33%"
      node_soak_duration_in_minutes = 0
    }

    tags = {
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  oms_agent {
    log_analytics_workspace_id      = var.workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  linux_profile {
    admin_username = "aksadmin"
    ssh_key {
      key_data = tls_private_key.ssh_key.public_key_openssh
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    dns_service_ip    = var.dns_service_ip
    service_cidr      = var.service_cidr
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  auto_scaler_profile {
    balance_similar_node_groups      = true
    scale_down_delay_after_add       = "10m"
    scale_down_unneeded              = "10m"
    scale_down_utilization_threshold = "0.5"
  }

  service_mesh_profile {
    mode                             = "Istio"
    internal_ingress_gateway_enabled = true
    external_ingress_gateway_enabled = true
    revisions                        = [var.istio_revision]
  }

  # Scheduled maintenance window for AKS control-plane auto-upgrades
  maintenance_window_auto_upgrade {
    frequency   = "Weekly"
    interval    = 1
    day_of_week = "Sunday"
    start_time  = "02:00"
    duration    = 4
    utc_offset  = "-03:00"
  }

  # Scheduled maintenance window for node OS image updates
  maintenance_window_node_os {
    frequency   = "Weekly"
    interval    = 1
    day_of_week = "Sunday"
    start_time  = "03:00"
    duration    = 4
    utc_offset  = "-03:00"
  }

  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [2, 3]
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      kubernetes_version,
    ]
  }

  tags = {
    Environment = var.environment
    Project     = var.proj_name
  }

  depends_on = [azurerm_user_assigned_identity.aks_identity]
}

resource "azurerm_kubernetes_cluster_node_pool" "wrk_nodepool" {
  name                  = "wrknodepool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.node_vm_size
  zones                 = ["1"]
  auto_scaling_enabled  = true
  max_count             = var.max_count
  min_count             = var.min_count
  vnet_subnet_id        = var.subnetaks_id
  os_disk_size_gb       = 30
  os_disk_type          = "Managed"
  os_type               = "Linux"
  mode                  = "User"

  priority        = var.environment == "des" ? "Spot" : "Regular"
  eviction_policy = var.environment == "des" ? "Deallocate" : null
  spot_max_price  = var.environment == "des" ? -1 : null

  node_labels = merge(
    {
      "nodepool-type" = "user"
      "environment"   = var.environment
      "nodepoolos"    = "linux"
    },
    var.environment == "des" ? {
      "kubernetes.azure.com/scalesetpriority" = "spot"
    } : {}
  )

  node_taints = var.environment == "des" ? ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"] : []

  upgrade_settings {
    drain_timeout_in_minutes      = 0
    max_surge                     = "33%"
    node_soak_duration_in_minutes = 0
  }

  tags = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
  }

  lifecycle {
    ignore_changes = [node_count]
  }

  depends_on = [azurerm_kubernetes_cluster.aks]
}

# kubeconfig files
resource "local_file" "kubeconfig" {
  depends_on      = [azurerm_kubernetes_cluster.aks]
  filename        = "${path.root}/secrets/kubeconfig"
  content         = azurerm_kubernetes_cluster.aks.kube_config_raw
  file_permission = "0600"
}

resource "local_file" "kubeconfigyaml" {
  depends_on      = [azurerm_kubernetes_cluster.aks]
  content         = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename        = "${path.root}/secrets/kubeconfig.yaml"
  file_permission = "0600"
}
