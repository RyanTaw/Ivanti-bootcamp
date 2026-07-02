variable "resource_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type    = string
  default = "0de2b198-522f-47c8-a44b-d3a98712404f"
}

variable "sql_admin_username" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "key_vault_name" {
  type    = string
  default = "bootcamp"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "bootcamp"
}

variable "owner_email" {
  description = "Owner email."
  type        = string
  default     = "ryan4shift@gmail.com"
}
