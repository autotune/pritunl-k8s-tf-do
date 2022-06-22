terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.17.1"
    }
  }
}

provider "digitalocean" {
  token   = var.do_token
  version = ">=1.5.0"
}

provider "grafana/grafana" {
  url  = "${var.loki_domain[0]}/grafana"
  auth = var.grafana_api_key
}
