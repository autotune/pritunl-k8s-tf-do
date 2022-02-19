resource "digitalocean_loadbalancer" "ingress_load_balancer" {
  name   = "${var.do_k8s_name}-lb"
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
