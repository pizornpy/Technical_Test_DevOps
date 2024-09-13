#Part of this is coming from the official docs https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#example-usage-attaching-a-container-registry-to-a-kubernetes-cluster

resource "azurerm_resource_group" "new_resource_group" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_container_registry" "destionation_acr" {
  name                = "instsance.azurerc.io"
  resource_group_name = azurerm_resource_group.new_resource_group.name
  location            = azurerm_resource_group.new_resource_group.location
  sku                 = "Premium"
}

resource "azurerm_kubernetes_cluster" "new_cluster" {    
  name                = "new_aks_cluster"
  location            = azurerm_resource_group.new_resource_group.location
  resource_group_name = azurerm_resource_group.new_resource_group.name
  dns_prefix          = "new_aks_cluster"

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

resource "azurerm_role_assignment" "new_az_role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.new_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.destionation_acr.id
  skip_service_principal_aad_check = true
}


resource "null_resource" "import_helm_charts" {
  for_each = toset(var.helm_charts)

  provisioner "local-exec" {
    command = <<EOT
    az acr import --name ${azurerm_container_registry.destination_acr.name} \
      --source reference.azurecr.io/helm/${each.key}:latest \
      --source-username ${var.reference_registry_username} \
      --source-password ${var.reference_registry_password} \
      --subscription c9e7611c-d508-4f-aede-0bedfabc1560 \
      --repository helm/${each.key} \
      --force
    EOT
  }
}