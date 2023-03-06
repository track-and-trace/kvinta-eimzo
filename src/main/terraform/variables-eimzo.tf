variable "eimzo_enable" {
  type    = bool
  default = false
}

variable "eimzo_config" {
  type        = map(any)
  description = "Eimzo container data."
  default     = {}
}
