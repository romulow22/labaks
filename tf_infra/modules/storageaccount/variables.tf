variable "proj_name" {
  description = "Project name"
  type        = string
}

variable "location" {
  description = "Location for the Event Hub"
  type        = string
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}


variable "aks_identity_principal_id" {
  type        = string
  description = "aks_identity_principal_id"
}


variable "rg_id" {
  type        = string
  description = "resource group id"
}

variable "account_kind" {
  description = "(Optional) Specifies the account kind of the storage account"
  type        = string
}
variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type        = string
}
variable "account_tier" {
  description = "Specifies the account tier of the storage account"
  type        = string
}
variable "replication_type" {
  description = "Specifies the replication type of the storage account"
  type        = string
}

variable "default_action" {
  description = "Allow or disallow public access to all blobs or containers in the storage accounts."
  type        = string
  validation {
    condition     = contains(["Allow", "Deny"], var.default_action)
    error_message = "default_action must be Allow or Deny."
  }
}

# azurerm 4.x: maps to allow_nested_items_to_be_public in the resource
variable "allow_blob_public_access" {
  description = "Allow public access to blobs/containers. Should be false for security."
  type        = bool
  default     = false
}

variable "container_name" {
  description = " (Required) The name of the Container within the Blob Storage Account where kafka messages should be captured"
  type        = string

}

variable "container_access_type" {
  description = "(Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private."
  type        = string

}
variable "file_share_name" {
  description = " (Required) The name of the File Share within the Storage Account where Files should be stored"
  type        = string
}

variable "file_share_quota" {
  description = " (Required) The maximum size of the share, in gigabytes."
  type        = number
}

variable "workspace_id" {
  type        = string
  description = "workspace_id"
}