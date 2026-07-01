output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

# output "key_vault_name" {
#   value = azurerm_key_vault.kv.name
# }

# output "sql_server_name" {
#   value = azurerm_mssql_server.sql_server.name
# }

# output "sql_database_name" {
#   value = azurerm_mssql_database.sql_db.name
# }