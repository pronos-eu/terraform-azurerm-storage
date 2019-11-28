# Azure Storage

Create storage account in Azure.

## Example Usage

```hcl
resource "azurerm_resource_group" "main" {
  name     = "example-resources"
  location = "westeurope"
}

module "storage" {
  source = "innovationnorway/storage/azurerm"

  name = "example"

  resource_group_name = azurerm_resource_group.main.name

  kind = "FileStorage"

  shares = [
    {
      name  = "example"
      quota = 5120
    }
  ]
}
```

## Arguments
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name of the storage account. | string | n/a | yes |
| resource\_group\_name | The name of an existing resource group. | string | n/a | yes |
| access\_tier | The access tier of the storage account. | string | `"Hot"` | no |
| assign\_identity | Set to `true` to enable system-assigned managed identity, or `false` to disable it. | bool | `"true"` | no |
| blobs | List of storage blobs. | list(any) | `[]` | no |
| containers | List of storage containers. | object | `[]` | no |
| cors\_blob\_allowed\_headers | The request headers that the origin domain may specify on the CORS request. | list(string) | `[ "*" ]` | no |
| cors\_blob\_allowed\_methods | The methods \(HTTP request verbs\) that the origin domain may use for a CORS request. | list(string) | `"null"` | no |
| cors\_blob\_allowed\_origins | The origin domains that are permitted to make a request against the storage service via CORS. The origin domain is the domain from which the request originates. Note that the origin must be an exact case-sensitive match with the origin that the user age sends to the service. You can also use the wildcard character '\*' to allow all origin domains to make requests via CORS. | list(string) | `"null"` | no |
| cors\_blob\_exposed\_headers | The response headers that may be sent in the response to the CORS request and exposed by the browser to the request issuer. | list(string) | `[ "*" ]` | no |
| cors\_blob\_max\_age | The maximum amount time that a browser should cache the preflight OPTIONS request. | number | `"60"` | no |
| https\_only | Set to `true` to only allow HTTPS traffic, or `false` to disable it. | bool | `"true"` | no |
| kind | The kind of storage account. | string | `"StorageV2"` | no |
| location | The name of the location. | string | `""` | no |
| queues | List of storages queues. | list(string) | `[]` | no |
| shares | List of storage shares. | object | `[]` | no |
| sku | The SKU of the storage account. | string | `"Standard_RAGRS"` | no |
| tables | List of storage tables. | list(string) | `[]` | no |
| tags |  | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| containers | Map of containers. |
| id | The ID of the storage account. |
| name | The name of the storage account. |
| primary\_access\_key | The primary access key for the storage account. |
| primary\_connection\_string | The primary connection string for the storage account. |
| shares | Map of shares. |
| tables | Map of tables. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
