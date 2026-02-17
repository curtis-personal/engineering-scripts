# Create Secret
resource "azurerm_key_vault_secret" "secret" {
  name         = var.secret_name
  value        = "securesecretvalue"
  key_vault_id = data.azurerm_key_vault.example.id
}