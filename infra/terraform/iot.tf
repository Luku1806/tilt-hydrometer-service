resource "azurerm_iothub" "tilt" {
  location            = var.tilt_rg_location
  resource_group_name = var.tilt_rg_name
  name                = "tilt-iot-hub"

  fallback_route {
    enabled = false
  }

  sku {
    name     = "F1"
    capacity = 1
  }
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

resource "azurerm_iothub_route" "tilt_eventhub" {
  name                = "eventhub"
  enabled             = true
  resource_group_name = azurerm_resource_group.tilt.name
  iothub_name         = azurerm_iothub.tilt.name
  source              = "TwinChangeEvents"
  endpoint_names      = [
    "events"
  ]
}

locals {
  iot_hub_default_eventhub_connection_string = "Endpoint=${azurerm_iothub.tilt.event_hub_events_endpoint};SharedAccessKeyName=${azurerm_iothub_shared_access_policy.tilt_functions.name};SharedAccessKey=${azurerm_iothub_shared_access_policy.tilt_functions.primary_key};EntityPath=${azurerm_iothub.tilt.event_hub_events_path}"
}
