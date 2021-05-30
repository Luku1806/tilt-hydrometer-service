resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "tilts" {
  name                = "tilt"
  location            = azurerm_resource_group.tilt.location
  resource_group_name = azurerm_resource_group.tilt.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_free_tier = true

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }


  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = azurerm_resource_group.tilt.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "tilts" {
  name                = "tilts"
  resource_group_name = azurerm_resource_group.tilt.name
  account_name        = azurerm_cosmosdb_account.tilts.name
  throughput          = 400
}
