resource "helm_release" "nginx_ingress_chart" {
  name       = "nginx-ingress-controller"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "service.annotations.kubernetes\\.digitalocean\\.com/load-balancer-id"
    value = digitalocean_loadbalancer.ingress_load_balancer.id
  }
  depends_on = [
    digitalocean_loadbalancer.ingress_load_balancer,
  ]
}

resource "kubernetes_ingress" "default_cluster_ingress" {
  depends_on = [
    helm_release.nginx_ingress_chart,
  ]
  metadata {
    name = "${local.name}-ingress"
    namespace  = "default"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "letsencrypt-production"
    }
  }
  spec {
    dynamic "rule" {
      content {
        host = rule.value
        http {
          path {
            backend {
              service_name = "${var.domain_name}-service"
              service_port = 80
            }
            path = "/"
          }
        }
      }
    }
    dynamic "tls" {
      content {
        secret_name = "${var.domain_name}-tls"
        hosts = [tls.value]
      }
    }
  }
}
