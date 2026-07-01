module "template1" {
  source = "./modules/template1"

  resource_name      = var.resource_name
  location           = var.location
  tenant_id          = var.tenant_id
  sql_admin_username = var.sql_admin_username
  sql_admin_password = var.sql_admin_password
  key_vault_name = azurerm_key_vault.name
}