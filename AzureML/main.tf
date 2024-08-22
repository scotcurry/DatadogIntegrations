# Log in with az login --tenant $AZURE_TENANT_ID

data "azurerm_client_config" "current_config" {}

resource "azurerm_resource_group" "curryware_ml_resource_group" {
    location = "northcentralus"
    name = "Curryware_ML_Resources"
    tags = {
        "env" = "curryware"
    }
}

resource "azurerm_application_insights" "curryware_azure_insights" {
    name = "curryware_ml_app_insights"
    location = azurerm_resource_group.curryware_ml_resource_group.location
    resource_group_name = azurerm_resource_group.curryware_ml_resource_group.name
    application_type = "web"
}

resource "azurerm_key_vault" "curryware_ml_key_vault" {
    name = "currywaremlkeyvault"
    location = azurerm_resource_group.curryware_ml_resource_group.location
    resource_group_name = azurerm_resource_group.curryware_ml_resource_group.name
    tenant_id = data.azurerm_client_config.current_config.tenant_id
    sku_name = "standard"
}

resource "azurerm_storage_account" "curryware_ml_storage_account" {
    name = "currywaremlstorageacct"
    location = azurerm_resource_group.curryware_ml_resource_group.location
    resource_group_name = azurerm_resource_group.curryware_ml_resource_group.name
    account_tier = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_machine_learning_workspace" "curryware_ml_workspace" {
    name = "curryware_ml_workspace"
    location = azurerm_resource_group.curryware_ml_resource_group.location
    resource_group_name = azurerm_resource_group.curryware_ml_resource_group.name
    application_insights_id = azurerm_application_insights.curryware_azure_insights.id
    key_vault_id = azurerm_key_vault.curryware_ml_key_vault.id
    storage_account_id = azurerm_storage_account.curryware_ml_storage_account.id

    identity {
        type = "SystemAssigned"
    }
}

resource "azurerm_virtual_network" "curryware_ml_vnet" {
    name = "curryware_ml_vnet"
    address_space = ["10.1.0.0/16"]
    location = azurerm_resource_group.curryware_ml_resource_group.location
    resource_group_name = azurerm_resource_group.curryware_ml_resource_group.name
}

resource "azurerm_subnet" "curryware_ml_subnet" {
    name = "curryware_ml_subnet"
    address_prefixes = ["10.1.0.0/24"]
    virtual_network_name = azurerm_virtual_network.curryware_ml_vnet.name
    resource_group_name = azurerm_resource_group.curryware_ml_resource_group.name
}

# resource "azurerm_machine_learning_compute_instance" "curryware_ml_compute" {
#     name = "currywaremlcompute"
#     location = azurerm_resource_group.curryware_ml_resource_group.location
#     machine_learning_workspace_id = azurerm_machine_learning_workspace.curryware_ml_workspace.id
#     virtual_machine_size = "STANDARD_DS3_v2"
#     authorization_type = "personal"
#     subnet_resource_id = azurerm_subnet.curryware_ml_subnet.id
#     tags = {
#         "dev" = "prod"
#     }
# }