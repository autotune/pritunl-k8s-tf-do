resource "kubernetes_namespace" "loki" {
  metadata {
    name = "loki"
  }
}

resource "helm_release" "loki" {
  depends_on = [kubernetes_namespace.loki]
  name       = "loki"
  namespace  = "loki" 
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "2.12.2"

  values = [
    sensitive("${file("loki.yaml")}")
  ]
}

/*
resource "kubernetes_ingress" "loki_cluster_ingress" {
  depends_on = [
    helm_release.nginx_ingress_chart, helm_release.loki
  ]
  for_each = toset(var.domain_name)
  metadata {
    name = "${each.key}-loki-ingress"
    namespace  = "loki"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "zerossl"
        "nginx.ingress.kubernetes.io/auth-url" = "https://$host/oauth2/auth"
        "nginx.ingress.kubernetes.io/auth-signin" = "https://$host/oauth2/start?rd=https://$host$request_uri$is_args$args"
    }
*/
