resource "azurerm_storage_account" "webpage" {
  name                      = "tiltpage"
  resource_group_name       = azurerm_resource_group.tilt.name
  location                  = azurerm_resource_group.tilt.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  static_website {
    index_document = "index.html"
  }
}
