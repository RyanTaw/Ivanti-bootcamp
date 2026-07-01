# resource "azurerm_key_vault_secret" "tenant_id" {
#   name         = "tenant-id"
#   value        = data.azurerm_client_config.current.tenant_id
#   key_vault_id = azurerm_key_vault.kv.id

#   content_type = "Terraform Managed"
# }

# resource "azurerm_key_vault_secret" "sql_admin_username" {
#   name         = "sql-admin-username"
#   value        = var.sql_admin_username
#   key_vault_id = azurerm_key_vault.kv.id

#   content_type = "Terraform Managed"
# }

# resource "azurerm_key_vault_secret" "sql_admin_password" {
#   name         = "sql-admin-password"
#   value        = var.sql_admin_password
#   key_vault_id = azurerm_key_vault.kv.id

#   content_type = "Terraform Managed"
# }