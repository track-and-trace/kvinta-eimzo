variable "stack_name" {
  type        = string
  description = "Application stack name"
  default     = "default"
}

variable "stack_version" {
  type        = string
  description = "Application stack version"
  default     = "latest"
}

variable "cloud_name" {
  type        = string
  description = "Application cloud name"
  default     = "default"
}

variable "cloud_version" {
  type        = string
  description = "Application cloud version"
  default     = "latest"
}

