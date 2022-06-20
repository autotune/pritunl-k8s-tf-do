resource "kubernetes_namespace" "loki" {
  metadata {
    name = "loki"
  }
}

resource "helm_release" "loki" {
  depends_on = [kubernetes_namespace.loki]
  name       = "loki"
  # namespace  = "loki" 
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "2.12.2"
}

resource "kubernetes_ingress" "loki_cluster_ingress" {
  depends_on = [
    helm_release.loki
  ]
  for_each = toset(var.domain_name)
  metadata {
    name = "${each.key}-loki-ingress"
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
      for_each = toset(var.domain_name)
      content {
        host = "loki.${rule.value}"
        http {
          path {
            backend {
              service_name = "loki"
              service_port = 3100
            }
            path = "/"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.domain_name)
      content {
        secret_name = "${replace(tls.value, ".", "-")}-atlantis-tls"
        hosts = ["terraform.${tls.value}"]
      }
    }
  }
}
