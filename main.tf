terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.42.0"
    }
  }
}

provider "azurerm" {
  features {  
  }
  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "rgtata" {
  name     = "rg-tata"
  location = "East US"
}

resource "azurerm_storage_account" "storagetata" {
  depends_on = [azurerm_resource_group.rgtata]
  name                     = "aksstoragetata"
  resource_group_name      = azurerm_resource_group.rgtata.name
  location                 = azurerm_resource_group.rgtata.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "contata" {
  depends_on = [azurerm_storage_account.storagetata]
  name                  = "contata"
  storage_account_id  = azurerm_storage_account.storagetata.id
  container_access_type = "private"
}


resource "azurerm_key_vault" "keyvaulttata" {
  depends_on            = [azurerm_resource_group.rgtata]
  name                  = "keyvaulttata"
  location              = azurerm_resource_group.rgtata.location
  resource_group_name   = azurerm_resource_group.rgtata.name
  sku_name              = "standard"
  tenant_id             = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled   = true
  purge_protection_enabled = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]
  }
}






# resource "azurerm_kubernetes_cluster" "clustertata" {
#   depends_on          = [azurerm_resource_group.rgtata]
#   name                = "nagendra"
#   location            = azurerm_resource_group.rgtata.location
#   resource_group_name = azurerm_resource_group.rgtata.name
#   dns_prefix          = "princeprefix"

#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_B2s"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = {
#     Environment = "Production"
#   }
# }

# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.clustertata.kube_config[0].client_certificate
#   sensitive = true
# }

# output "kube_config" {
#   value     = azurerm_kubernetes_cluster.clustertata.kube_config_raw
#   sensitive = true
# }

