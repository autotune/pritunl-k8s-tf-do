resource "digitalocean_loadbalancer" "ingress_load_balancer" {
  name   = "${var.do_k8s_name}-lb"
  region = var.do_region
  size = "lb-small"
  algorithm = "round_robin"

  forwarding_rule {
    entry_port     = 80 
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"

  }

  lifecycle {
      ignore_changes = [
        forwarding_rule,
    ]
  }

}

resource "digitalocean_loadbalancer" "atlantis_ingress_load_balancer" {
  name   = "${var.do_k8s_name}-atlantis-lb"
  region = var.do_region
  size = "lb-small"
  algorithm = "round_robin"

  forwarding_rule {
    entry_port     = 80 
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"

  }

  lifecycle {
      ignore_changes = [
        forwarding_rule,
    ]
  }

}
