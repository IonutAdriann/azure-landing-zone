terraform{
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.14.0"
      }
    }
}

provider "azurerm" {
    subscription_id = var.subscription_id
    features{}
}

resource "azurerm_resource_group" "resource_group"{
    name = "${var.project}-${var.environment}-resource-group"
    location = var.location
}

resource "azurerm_storage_account" "storage_account" {
    name= "${var.project}${var.environment}storage"
    resource_group_name = azurerm_resource_group.resource_group.name
    location = var.location 
    account_tier = "standard"
    account_replication_type = "LRS"
}

resource "azurerm_application_insights" "application_insights" {
    name = "${var.project}${var.environment}storage"
    location = var.location
    resource_group_name = azurerm_resource_group.resource_group.name
    application_type = ""
}

resource "azurerm_app_service_plan" "app_service_plan" {
    name = "${var.project}-${var.environment}-app-service-plan"
    resource_group_name = azurerm_resource_group.resource_group.name
    location = var.location
    kind = "FunctionApp"
    reserved = true
    sku {
        tier = "Dynamic"
        size = "Y1"
    }
}

resource "azurerm_function_app" "function_app" {
    name = "${var.project}-${var.environment}-function-app"
    resource_group_name = azurerm_resource_group.resource_group.name
    location = var.location
    app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
    app_settings = {
        "WEBSITE_RUN_FROM_PACKAGE" = "",
        "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.application_insights.instrumentation_key,
    }
    os_type = "linux"
    storage_account_name       = azurerm_storage_account.storage_account.name
    storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
    version                    = "~3"

    lifecycle {
        ignore_changes = [
        app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
    }
}