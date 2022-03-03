variable "do_k8s_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `k8s-do`)"
  type        = string
  default     = "k8s-do"
}

variable "do_token" {
  description = "Digital Ocean Personal access token"
  type        = string
  default     = ""
}
