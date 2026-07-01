resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${local.prefix}-aks-mi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.tags
}