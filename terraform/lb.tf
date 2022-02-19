resource "digitalocean_loadbalancer" "ingress_load_balancer" {
  name   = "${local.name}-lb"
  region = var.do_region
  size = "lb-small"
  algorithm = "round_robin"

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 443
    target_protocol = "https"

  }

  lifecycle {
      ignore_changes = [
        forwarding_rule,
    ]
  }

}
