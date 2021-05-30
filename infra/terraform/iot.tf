resource "azurerm_iothub" "tilt" {
  location            = var.tilt_rg_location
  resource_group_name = var.tilt_rg_name
  name                = "tilt-iot-hub"

  sku {
    name     = "F1"
    capacity = 1
  }
}

resource "azurerm_iothub_endpoint_eventhub" "tilt_eventhub" {
  name                = azurerm_eventhub.tilt_twin_updates.name
  resource_group_name = azurerm_resource_group.tilt.name
  iothub_name         = azurerm_iothub.tilt.name
  connection_string = azurerm_eventhub_authorization_rule.tilt_twin_updates.primary_connection_string
}

resource "azurerm_iothub_route" "tilt_eventhub" {
  name                = "eventhub"
  resource_group_name = azurerm_resource_group.tilt.name
  iothub_name         = azurerm_iothub.tilt.name
  endpoint_names      = [azurerm_iothub_endpoint_eventhub.tilt_eventhub.name]
  source              = "TwinChangeEvents"
  enabled             = true
}

resource "azurerm_iothub_shared_access_policy" "tilt_functions" {
  name                = "tilt_functions"
  resource_group_name = azurerm_resource_group.tilt.name
  iothub_name         = azurerm_iothub.tilt.name

  registry_read   = true
  registry_write  = true
  service_connect = true
  device_connect  = true
}

resource "azurerm_eventhub_namespace" "tilt_twin_updates" {
  name                = "tilt-device-twin"
  location            = azurerm_resource_group.tilt.location
  resource_group_name = azurerm_resource_group.tilt.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "tilt_twin_updates" {
  name                = "tilt-events"
  namespace_name      = azurerm_eventhub_namespace.tilt_twin_updates.name
  resource_group_name = azurerm_resource_group.tilt.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "tilt_twin_updates" {
  name                = "iot_hub"
  resource_group_name = azurerm_resource_group.tilt.name
  namespace_name      = azurerm_eventhub_namespace.tilt_twin_updates.name
  eventhub_name       = azurerm_eventhub.tilt_twin_updates.name
  listen              = true
  send                = true
  manage              = false
}
