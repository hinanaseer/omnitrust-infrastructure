# 1. Define Terraform Providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 2. Enterprise Resource Group
resource "azurerm_resource_group" "omnicloud_rg" {
  name     = "omnicloud-prod-rg"
  location = "East US"
}

# 3. Azure Container Registry (ACR)
resource "azurerm_container_registry" "omnicloud_acr" {
  name                = "omnicloudregistry" # Must be globally unique
  resource_group_name = azurerm_resource_group.omnicloud_rg.name
  location            = azurerm_resource_group.omnicloud_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 4. Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "omnicloud_aks" {
  name                = "hina-omnicloud-aks-prod"
  location            = azurerm_resource_group.omnicloud_rg.location
  resource_group_name = azurerm_resource_group.omnicloud_rg.name
  dns_prefix          = "omnicloud-aks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2s_v3" # Cost-effective for practice
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "OmniTrust"
  }
}

# 5. Role Assignment: Allow AKS to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.omnicloud_aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.omnicloud_acr.id
  skip_service_principal_aad_check = true
}