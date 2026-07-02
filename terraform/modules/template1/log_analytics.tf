resource "azurerm_log_analytics_workspace" "log" {
  name                = "${local.prefix}-log"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  retention_in_days   = 30

  tags = local.tags
}