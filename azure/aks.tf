resource "azurerm_resource_group" "example" {
  name     = "terakube-aks-example-resources"
  location = "North Europe"
}

resource "azurerm_kubernetes_cluster" "example1" {
  name                = "example-aks1"
  kubernetes_version  = "1.29.4"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_kubernetes_cluster" "example2" {
  name                = "example-aks2"
  kubernetes_version  = "1.29.4"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks2"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}