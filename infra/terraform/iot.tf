resource "azurerm_iothub" "tilt" {
  location            = var.tilt_rg_location
  resource_group_name = var.tilt_rg_name
  name                = "tilt-iot-hub"

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
