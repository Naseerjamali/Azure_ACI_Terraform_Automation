data "azurerm_container_registry" "acr_data" {
  name                = azurerm_container_registry.acr.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg_name.id
  location = var.resource_group_location
}

resource "azurerm_container_registry" "acr" {
  name                = "netstatacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
  identity {
    type = "SystemAssigned"
  }
  # georeplications {
  #  location                = "East US"
  #  zone_redundancy_enabled = true
  # tags                    = {}
  #}
  # georeplications {
  #  location                = "North Europe"
  # zone_redundancy_enabled = true
  #tags                    = {}
  #}
}


resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_container_group" "container" {
  name                = "${var.container_group_name_prefix}-${random_string.container_name.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = var.restart_policy
  dns_name_label      = var.dns-name-label

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr_data.admin_username
    password = data.azurerm_container_registry.acr_data.admin_password
  }

  container {
    name   = "${var.container_name_prefix}-${random_string.container_name.result}"
    image  = var.image
    cpu    = var.cpu_cores
    memory = var.memory_in_gb

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }
  depends_on = [azurerm_container_registry.acr]
}

resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_container_registry.acr.identity[0].principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# resource "image_registry_credential" {

# }