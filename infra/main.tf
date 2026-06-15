provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "redis-api-rg"
  location = "East US"
}

resource "azurerm_redis_cache" "redis" {
  name                = "redis-api-cache-fperez"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"
}

resource "azurerm_service_plan" "plan" {
  name                = "redis-api-appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "redis-api-webapp-fperez"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      docker_image_name     = "DOCKERHUB_USERNAME/redis-api:latest"
      docker_registry_url   = "https://index.docker.io/v1/"
    }
  }

  app_settings = {
    "REDIS_CONNECTION_STRING" = azurerm_redis_cache.redis.primary_connection_string
  }
}
