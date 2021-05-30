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
  kind                = "functionapp"
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

  auth_settings {
    enabled                       = true
    default_provider              = "Google"
    unauthenticated_client_action = "RedirectToLoginPage"

    google {
      client_id     = var.google_oauth_client_id
      client_secret = var.google_oauth_client_secret
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME: "node"
    IOT_HUB_CONNECTION_STRING: azurerm_iothub_shared_access_policy.tilt_functions.primary_connection_string
    EVENT_HUB_CONNECTION_STRING: azurerm_eventhub_namespace.tilt_twin_updates.default_primary_connection_string
    COSMOS_DB_CONNECTION_STRING: azurerm_cosmosdb_account.tilts.connection_strings[0]
    COSMOS_DB_NAME: azurerm_cosmosdb_mongo_database.tilts.name
  }
}
