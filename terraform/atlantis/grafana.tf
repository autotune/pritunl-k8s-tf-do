resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "6.30.2"
  values = [file("grafana.yaml")]
}

resource "kubernetes_ingress" "grafana_cluster_ingress" {
  depends_on = [
    helm_release.loki
  ]
  for_each = toset(var.loki_domain)
  metadata {
    name = "${each.key}-grafana-ingress"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "zerossl"
        "nginx.ingress.kubernetes.io/auth-url" = "https://$host/oauth2/auth"
        "nginx.ingress.kubernetes.io/auth-signin" = "https://$host/oauth2/start?rd=https://$host$request_uri$is_args$args"
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
              service_name = "grafana"
              service_port = 3000
            }
            path = "/grafana"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.loki_domain)
      content {
        secret_name = "${replace(tls.value, ".", "-")}-grafana-tls"
        hosts = ["${tls.value}"]
      }
    }
  }
}
