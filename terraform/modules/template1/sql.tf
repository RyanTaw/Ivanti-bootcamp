resource "azurerm_mssql_server" "sql_server" {
  name                         = "${local.prefix}-sql"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  tags = local.tags
}

resource "azurerm_mssql_database" "sql_db" {
  name      = "${local.prefix}-db"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic"

  tags = local.tags
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}