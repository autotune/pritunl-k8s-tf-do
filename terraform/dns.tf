data "digitalocean_domain" "default" {
  for_each = toset(var.domain_name)
  name = each.value
}

resource "digitalocean_record" "a_records" {
  for_each = toset(var.domain_name)
  domain = each.value 
  type   = "A"
  ttl = 60
  name   = "@"
  value  = digitalocean_loadbalancer.ingress_load_balancer.ip
  depends_on = [
    kubernetes_ingress.default_cluster_ingress
  ]
}

resource "digitalocean_record" "atlantis" {
  for_each = toset(var.domain_name)
  domain = "atlantis.${each.value}"
  type   = "A"
  ttl = 60
  name   = "@"
  value  = digitalocean_loadbalancer.ingress_load_balancer.ip
  depends_on = [
    kubernetes_ingress.default_cluster_ingress
  ]
}
