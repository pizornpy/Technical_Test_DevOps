#Part of this is coming from the official docs https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#example-usage-attaching-a-container-registry-to-a-kubernetes-cluster

data "azurerm_resource_group" "existing_resource_group" {  #Changed after seeing that i can assume its created
  name     = "test-resource-group"
  location = "West Europe"    #I dont know which one so i leave as is
}

data "azurerm_kubernetes_cluster" "existing_cluster" {
  name                = "existing_aks_cluster"  
  resource_group_name = data.azurerm_resource_group.existing_resource_group.name
}

resource "azurerm_container_registry" "destination_acr" { #Changed after seeing that i can assume its created
  name                = "instsance.azurerc.io"
  resource_group_name = azurerm_resource_group.existing_resource_group.name
  location            = azurerm_resource_group.existing_resource_group.location
  sku                 = "Premium"
}



resource "azurerm_role_assignment" "new_az_role_assignment" {   #Role assigment to pull images
  principal_id                     = azurerm_kubernetes_cluster.new_cluster.kubelet_identity[0].object_id   
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.destination_acr.id
  skip_service_principal_aad_check = true
}


resource "null_resource" "import_helm_charts" {   #null resource to import charts
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

