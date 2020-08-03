variable "module_info" {
  type = map
}

variable "workspace_tags" {
    type = map
}

variable "tier" {
  description = "Specifies the plan's pricing tier"
  default     = "Basic"
}

variable "size" {
  description = "Specifies the plan's instance size"
  default     = "B1"
}