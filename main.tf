locals {
  blobs = [
    for b in var.blobs : merge({
      type         = "block"
      size         = 0
      content_type = "application/octet-stream"
      source_file  = null
      source_uri   = null
      attempts     = 1
      metadata     = {}
    }, b)
  ]

  account_tier             = (var.kind == "FileStorage" ? "Premium" : split("_", var.sku)[0])
  account_replication_type = (local.account_tier == "Premium" ? "LRS" : split("_", var.sku)[1])
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "main" {
  name                      = var.name
  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = coalesce(var.location, data.azurerm_resource_group.main.location)
  account_kind              = var.kind
  account_tier              = local.account_tier
  account_replication_type  = local.account_replication_type
  access_tier               = var.access_tier
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = var.https_only
  tags                      = var.tags

  identity {
    type = var.assign_identity ? "SystemAssigned" : null
  }
}

resource "azurerm_storage_container" "main" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = var.containers[count.index].access_type
}

resource "azurerm_storage_queue" "main" {
  count                = length(var.queues)
  name                 = var.queues[count.index]
  storage_account_name = azurerm_storage_account.main.name
}

resource "azurerm_storage_share" "main" {
  count                = length(var.shares)
  name                 = var.shares[count.index].name
  storage_account_name = azurerm_storage_account.main.name
  quota                = var.shares[count.index].quota
}

resource "azurerm_storage_table" "main" {
  count                = length(var.tables)
  name                 = var.tables[count.index]
  storage_account_name = azurerm_storage_account.main.name
}

resource "azurerm_storage_blob" "main" {
  count                  = length(local.blobs)
  name                   = local.blobs[count.index].name
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = local.blobs[count.index].container_name
  type                   = local.blobs[count.index].type
  size                   = local.blobs[count.index].size
  content_type           = local.blobs[count.index].content_type
  source                 = local.blobs[count.index].source_file
  source_uri             = local.blobs[count.index].source_uri
  metadata               = local.blobs[count.index].metadata
  depends_on             = [azurerm_storage_container.main]
}

# Workaround to set CORS

data "template_file" "cors_config" {
  template = <<CORS
    {
      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "storageAccountName": {
          "type": "string",
          "metadata": {
            "description": "Specifies the name of the Azure Storage account."
          }
        }
      },
      "resources": [
        {
          "type": "Microsoft.Storage/storageAccounts",
          "apiVersion": "2018-07-01",
          "name": "[parameters('storageAccountName')]",
          "location": "[resourceGroup().location]",
          "resources": [
            {
              "name": "default",
              "type": "blobServices",
              "apiVersion": "2018-07-01",
              "properties": {"cors": {"corsRules": [{"allowedOrigins": ["${join("\",\"", var.cors_blob_allowed_origins)}"], "allowedMethods": ["${join("\",\"", var.cors_blob_allowed_methods)}"], "maxAgeInSeconds": "${var.cors_blob_max_age}", "exposedHeaders": ["${join("\",\"", var.cors_blob_exposed_headers)}"], "allowedHeaders": ["${join("\",\"", var.cors_blob_allowed_headers)}"]}]}},
              "dependsOn": ["[concat('Microsoft.Storage/storageAccounts/', parameters('storageAccountName'))]"]
            }
          ]
        }
      ]
    }
  CORS
}

resource "azurerm_template_deployment" "cors_settings" {
  count               = length(var.cors_blob_allowed_origins) > 0 ? 1 : 0
  name                = "cors-settings"
  resource_group_name = data.azurerm_resource_group.main.name
  deployment_mode     = "Incremental"

  parameters = {
    storageAccountName = azurerm_storage_account.main.name
  }

  template_body = data.template_file.cors_config.rendered
}
