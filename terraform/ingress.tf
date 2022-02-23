data "github_ip_ranges" "default" {}

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
    digitalocean_loadbalancer.ingress_load_balancer
  ]
}

resource "kubernetes_ingress" "atlantis_cluster_ingress" {
  depends_on = [
    helm_release.nginx_ingress_chart
  ]
  for_each = toset(var.domain_name)
  metadata {
    name = "${each.key}-atlantis-ingress"
    namespace  = "atlantis"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "zerossl"
        "ingress.kubernetes.io/auth-url" = "https://auth.${each.key}/oauth2/auth"
        "ingress.kubernetes.io/auth-signin" = "https://auth.${each.key}/oauth2/start?rd=https://$host$request_uri$is_args$args"
    }
  }
  spec {
    dynamic "rule" {
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

resource "kubernetes_ingress" "oauth_cluster_ingress" {
  depends_on = [
    helm_release.nginx_ingress_chart
  ]
  for_each = toset(var.domain_name)
  metadata {
    name = "${each.key}-oauth2-ingress"
    namespace  = "oauth-proxy"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "zerossl"
    }
  }
  spec {
    dynamic "rule" {
      for_each = toset(var.domain_name)
      content {
        host = "auth.${rule.value}"
        http {
          path {
            backend {
              service_name = "${replace(rule.value, ".", "-")}-oauth2-service"
              service_port = 4180
            }
            path = "/oauth2"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.domain_name)
      content {
        secret_name = "${replace(tls.value, ".", "-")}-oauth-proxy-tls"
        hosts = ["auth.${tls.value}"]
      }
    }
  }
}
