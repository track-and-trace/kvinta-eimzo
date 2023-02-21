variable "image_tag" {
  type        = string
  description = "Docker image tag to use for this deployment"
  default     = "latest"
}

variable "this_version" {
  type        = string
  description = "Current module version"
  default     = "latest"
}

