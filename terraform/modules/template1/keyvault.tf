data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = replace("${local.prefix}-kv", "-", "")
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true

  tags = local.tags
}
