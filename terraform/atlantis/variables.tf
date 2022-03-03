variable "argocd_helm_chart_version" {
  type    = string
  default = "3.13.0"
}

variable "argocd_github_client_id" {
  type    = string
}

variable "argocd_github_client_secret" {
  type    = string
}

variable "argocd_ingress_enabled" {
  type    = string
  default = "true"
}

variable "argocd_ingress_tls_acme_enabled" {
  type    = string
  default = "true"
}

variable "argocd_ingress_ssl_passthrough_enabled" {
  type    = string
  default = "true"
}

variable "argocd_ingress_class" {
  type    = string
  default = "true"
}

variable "argocd_ingress_tls_secret_name" {
  type    = string
  default = "argocd-cert"
}
