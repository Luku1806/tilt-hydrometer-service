resource "azurerm_iothub" "tilt" {
  location            = var.tilt_rg_location
  resource_group_name = var.tilt_rg_name
  name                = "tilt-iot-hub"

  sku {
    name     = "F1"
    capacity = 1
  }
}
