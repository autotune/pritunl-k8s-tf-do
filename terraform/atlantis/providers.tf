terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.17.1"
    }
    grafana = {
      source = "grafana/grafana"
      version = ">=1.24.0"
    }
  }
}

provider "digitalocean" {
  token   = var.do_token
  version = ">=1.5.0"
}

provider "grafana" {
  url  = "https://${var.loki_domain[0]}/grafana"
  auth = var.grafana_api_key
}
