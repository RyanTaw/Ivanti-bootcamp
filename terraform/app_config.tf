variable "resource_name" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "key_vault_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "sql_admin_username" {
  type    = string
}

variable "sql_admin_password" {
  type = string
}