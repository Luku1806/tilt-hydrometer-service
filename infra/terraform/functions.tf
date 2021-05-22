resource "azurerm_storage_account" "tiltfunctions" {
  name                     = "tiltfunctionsapp"
  resource_group_name      = azurerm_resource_group.tilt.name
  location                 = azurerm_resource_group.tilt.location
  account_tier             = "Standard"
  access_tier              = "Cool"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "tiltfunctions" {
  name                = "tiltfunctionsapp-service-plan"
  resource_group_name = azurerm_resource_group.tilt.name
  location            = azurerm_resource_group.tilt.location
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "tiltfunctions" {
  name                       = "tilt-functions"
  resource_group_name        = azurerm_resource_group.tilt.name
  location                   = azurerm_resource_group.tilt.location
  app_service_plan_id        = azurerm_app_service_plan.tiltfunctions.id
  storage_account_name       = azurerm_storage_account.tiltfunctions.name
  storage_account_access_key = azurerm_storage_account.tiltfunctions.primary_access_key
  os_type                    = "linux"
  app_settings               = {
    FUNCTIONS_WORKER_RUNTIME: "node"
    IOT_HUB_CONNECTION_STRING: azurerm_iothub_shared_access_policy.tilt_functions.primary_connection_string
  }
}
