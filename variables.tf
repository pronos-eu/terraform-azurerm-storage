variable "name" {
  type        = string
  description = "The name of the storage account."
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group."
}

variable "location" {
  type        = string
  default     = ""
  description = "The name of the location."
}

variable "kind" {
  type        = string
  default     = "StorageV2"
  description = "The kind of storage account."
}

variable "sku" {
  type        = string
  default     = "Standard_RAGRS"
  description = "The SKU of the storage account."
}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = "The access tier of the storage account."
}

variable "https_only" {
  type        = bool
  default     = true
  description = "Set to `true` to only allow HTTPS traffic, or `false` to disable it."
}

variable "assign_identity" {
  type        = bool
  default     = true
  description = "Set to `true` to enable system-assigned managed identity, or `false` to disable it."
}

variable "blobs" {
  type        = list(any)
  default     = []
  description = "List of storage blobs."
}

variable "containers" {
  type = list(object({
    name        = string
    access_type = string
  }))
  default     = []
  description = "List of storage containers."
}

variable "queues" {
  type        = list(string)
  default     = []
  description = "List of storages queues."
}

variable "shares" {
  type = list(object({
    name  = string
    quota = number
  }))
  default     = []
  description = "List of storage shares."
}

variable "tables" {
  type        = list(string)
  default     = []
  description = "List of storage tables."
}

variable "tags" {
  type    = map
  default = {}
}

variable "cors_blob_allowed_origins" {
  type        = list(string)
  default     = null
  description = " The origin domains that are permitted to make a request against the storage service via CORS. The origin domain is the domain from which the request originates. Note that the origin must be an exact case-sensitive match with the origin that the user age sends to the service. You can also use the wildcard character '*' to allow all origin domains to make requests via CORS."
}

variable "cors_blob_allowed_methods" {
  type        = list(string)
  default     = null
  description = "The methods (HTTP request verbs) that the origin domain may use for a CORS request."
}

variable "cors_blob_allowed_headers" {
  type        = list(string)
  default     = ["*"]
  description = "The request headers that the origin domain may specify on the CORS request."
}

variable "cors_blob_exposed_headers" {
  type        = list(string)
  default     = ["*"]
  description = "The response headers that may be sent in the response to the CORS request and exposed by the browser to the request issuer."
}

variable "cors_blob_max_age" {
  type        = number
  default     = 60
  description = "The maximum amount time that a browser should cache the preflight OPTIONS request."
}
