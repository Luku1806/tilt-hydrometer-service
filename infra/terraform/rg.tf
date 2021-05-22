resource "azurerm_resource_group" "tilt" {
  location = var.tilt_rg_location
  name     = var.tilt_rg_name
}
