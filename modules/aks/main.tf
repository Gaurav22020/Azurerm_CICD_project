resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name

  private_cluster_enabled = true

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name           = "systempool"
    vm_size        = "Standard_B2s_v2"
    vnet_subnet_id = var.subnet_id

    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 3
  }

  network_profile {
    network_plugin = "azure"

    # 🔴 REQUIRED to avoid CIDR overlap
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }

  role_based_access_control_enabled = true
}


resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_B2s_v2"
  vnet_subnet_id        = var.subnet_id

  auto_scaling_enabled = true
  min_count            = 1
  max_count            = 5

  mode = "User"
}
