resource "helm_release" "prometheus" {
  depends_on = [kubernetes_namespace.loki]
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "15.10.1"
}


/*
resource "kubernetes_ingress" "loki_cluster_ingress" {
  depends_on = [
    helm_release.loki
  ]
  for_each = toset(var.loki_domain)
  metadata {
    name = "${each.key}-loki-ingress"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "zerossl"
        "nginx.ingress.kubernetes.io/auth-url" = "https://$host/oauth2/auth"
        "nginx.ingress.kubernetes.io/auth-signin" = "https://$host/oauth2/start?rd=https://$host$request_uri$is_args$args"
        "nginx.ingress.kubernetes.io/whitelist-source-range" = join(",", concat(local.extra_ips))
    }
  }
  spec {
    dynamic "rule" {
      for_each = toset(var.loki_domain)
      content {
        host = "${rule.value}"
        http {
          path {
            backend {
              service_name = "loki"
              service_port = 3100
            }
            path = "/loki"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.loki_domain)
      content {
        secret_name = "${replace(tls.value, ".", "-")}-loki-tls"
        hosts = ["${tls.value}"]
      }
    }
  }
}
*/
