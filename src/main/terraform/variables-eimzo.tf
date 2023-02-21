variable "eimzo_enable" {
  type    = bool
  default = false
}

variable "eimzo_config" {
  type        = map(string)
  description = "eimzo container data."
  default     = {}
}
