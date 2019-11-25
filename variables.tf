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
