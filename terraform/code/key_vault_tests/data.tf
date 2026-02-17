data "azurerm_key_vault" "example" {
  name                = var.kv_name
  resource_group_name = "rg-kv-policy-test"
}