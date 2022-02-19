data "digitalocean_domain" "default" {
  name = var.domain_name
}

resource "digitalocean_record" "a_records" {
  domain = var.domain_name 
  type   = "A"
  ttl = 60
  name   = "@"
  value  = digitalocean_loadbalancer.ingress_load_balancer.ip
  depends_on = [
    digitalocean_domain.top_level_domains,
    kubernetes_ingress.default_cluster_ingress
  ]
}
