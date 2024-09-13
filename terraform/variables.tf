variable "reference_registry_username" {
  type        = string
  description = "Username for the reference ACR"
}

variable "reference_registry_password" {
  type        = string
  description = "Password for the reference ACR"
}

variable "helm_charts" {
  type        = list(string)
  description = "List of Helm charts to import"
  default     = ["example-chart-1", "example-chart-2", "example-chart-n"]  
}

