provider "azurerm" {
  version = "~>2.20.0"
	features {}
}

resource "azurerm_resource_group" "rg" {
  name      = "test-resource-group"
  location  = "southeastasia"
}

resource "azurerm_application_insights" "appinsight" {  
  name                = "coreapi-appinsight"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"  
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "coreapi-appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
  sku {
    tier = "Basic"
    size = "F1"
  }
}

resource "azurerm_app_service" "appservice_appapi" {
  name                = "coreapi-appservice"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsight.instrumentation_key
  }
}
