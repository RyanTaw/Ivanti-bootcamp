resource "azurerm_dns_zone" "dns" {
  name                = "${local.prefix}.com"
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.tags
}