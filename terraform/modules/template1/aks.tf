resource "azurerm_public_ip" "cluster_public_ip" {
  name                = "${local.prefix}-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  tags = local.tags
}

resource "azurerm_role_assignment" "aks_public_ip_network_contributor" {
  scope                = azurerm_public_ip.cluster_public_ip.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = "${local.prefix}-aks"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  node_resource_group       = "${local.prefix}-aks-nodes"
  dns_prefix                = "${local.prefix}-aks"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name           = "bootcamp"
    vm_size        = "Standard_DC2as_v5"
    type           = "VirtualMachineScaleSets"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
    node_count     = 1
    max_pods       = 31

    node_labels = {
      app = "dotnet"
    }

    upgrade_settings {
      max_surge = "1"
    }

    tags = local.tags
  }

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.aks_identity.id
    ]
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "172.24.0.0/20"
    dns_service_ip = "172.24.0.10"

    load_balancer_profile {
      outbound_ip_address_ids = [
        azurerm_public_ip.cluster_public_ip.id
      ]
    }
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
  }

  tags = local.tags

  depends_on = [
    azurerm_role_assignment.aks_public_ip_network_contributor,
    azurerm_role_assignment.aks_vnet_network_contributor,
    azurerm_log_analytics_workspace.log
  ]
}