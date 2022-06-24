resource "grafana_data_source" "loki" {
  depends_on    = [helm_release.loki]
  type          = "loki"
  name          = "loki"
  url           = "http://loki:3100/"
}

resource "grafana_dashboard" "loki-metrics" {
  config_json = file("loki_dashboard.json")
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
              service_name = "prom-operator-grafana"
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
