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
    name = "${var.do_k8s_name}-ingress"
    namespace  = "default"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "letsencrypt-production"
    }
  }
  spec {
    dynamic "rule" {
      for_each = toset(var.domain_name)
      content {
        host = rule.value
        http {
          path {
            backend {
              service_name = "${replace(rule.value, ".", "-")}-service"
              service_port = 80
            }
            path = "/"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.domain_name)
      content {
        secret_name = "${replace(tls.value, ".", "-")}-tls"
        hosts = [tls.value]
      }
    }
  }
}

resource "kubernetes_ingress" "atlantis_cluster_ingress" {
  depends_on = [
    helm_release.nginx_ingress_chart,
  ]
  metadata {
    name = "${var.do_k8s_name}-atlantis-ingress"
    namespace  = "default"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "letsencrypt-production"
    }
  }
  spec {
    dynamic "rule" {
      for_each = toset(var.domain_name)
      content {
        host = "atlantis.${rule.value}"
        http {
          path {
            backend {
              service_name = "${replace(rule.value, ".", "-")}-atlantis-service"
              service_port = 80
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
        hosts = ["atlantis.${tls.value}"]
      }
    }
  }
}
