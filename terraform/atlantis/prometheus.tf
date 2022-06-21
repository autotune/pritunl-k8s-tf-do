resource "helm_release" "prometheus" {
  depends_on = [kubernetes_namespace.loki]
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "15.10.1"

  set {
    name  = "server.baseURL"
    value = "wayofthesys.com/prometheus"
  }
}


resource "kubernetes_ingress" "prometheus_cluster_ingress" {
  depends_on = [
    helm_release.prometheus
  ]
  for_each = toset(var.loki_domain)
  metadata {
    name = "${each.key}-prometheus-ingress"
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
              service_name = "prometheus-server"
              service_port = 80
            }
            path = "/prometheus"
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
