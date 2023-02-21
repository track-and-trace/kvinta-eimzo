variable "enabled" {
  type        = bool
  description = "Enable this service for creation"
  default     = true
}

variable "namespace" {
  type        = string
  description = "K8S namespace to put resources to"
  default     = "kvinta"
}

variable "replicas" {
  type        = number
  description = "Replicas count"
  default     = 1
}

variable "envs" {
  type        = map(any)
  description = "Environment variables to add to k8s ConfigMap"
  default     = {}
}

variable "sensitive_envs" {
  type        = map(any)
  description = "Environment variables to add to k8s Secret"
  default     = {}
}

variable "java_opts" {
  type        = list(string)
  description = "Set you JAVA_OPTS here"
  default     = []
}

variable "logging_enabled" {
  type        = bool
  description = "Enable logback logging feature"
  default     = true
}

variable "logging_format" {
  type        = string
  description = "Logback logging format"
  default     = "text"
}

variable "logging_levels" {
  type        = map(string)
  description = "Logging logger levels"
  default     = {}
}

variable "resources_options" {
  type        = map(string)
  description = "K8S resources options (request/limits)"
  default     = {}
}

variable "probes_enabled" {
  type        = map(string)
  description = "Which probes should be enabled: liveness, readiness, startup"
  default = {
    liveness = true
  }
}

variable "probes_options" {
  type        = map(string)
  description = "K8S probes options (liveness/readiness)"
  default     = {}
}

variable "image_registry" {
  type        = string
  description = "Image registry url"
}

variable "image_pull_policy" {
  type        = string
  description = "Image pull policy for main container"
  default     = "Always"
}
