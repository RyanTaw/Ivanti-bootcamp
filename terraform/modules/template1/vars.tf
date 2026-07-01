variable "resource_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
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
  default     = "DEV"
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
