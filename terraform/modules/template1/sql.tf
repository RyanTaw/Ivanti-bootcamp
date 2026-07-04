# resource "azurerm_mssql_server" "sql" {
#   name                         = "${local.prefix}-sql"
#   resource_group_name          = azurerm_resource_group.rg.name
#   location                     = azurerm_resource_group.rg.location
#   version                      = "12.0"
#   administrator_login          = var.sql_admin_username
#   administrator_login_password = var.sql_admin_password

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = local.tags
# }

# resource "azurerm_mssql_database" "appdb" {
#   name      = "${local.prefix}-db"
#   server_id = azurerm_mssql_server.sql.id

#   sku_name  = "Basic"
#   max_size_gb = 2

#   tags = local.tags
# }