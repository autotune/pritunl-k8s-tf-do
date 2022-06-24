resource "helm_release" "prometheus" {
  depends_on = [kubernetes_namespace.loki]
  name       = "prom-operator"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "36.0.3"
  values     = ["${file("grafana.yaml")}"]
  /*
  set {
    name  = "server.baseURL"
    value = "wayofthesys.com/prometheus"
  }

  set {
    name  = "server.prefixURL"
    value = "/"
  } */
}

resource "helm_release" "promtail" {
  depends_on = [kubernetes_namespace.loki]
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "5.1.0"
  values     = ["${file("promtail.yaml")}"]
  set {
    name  = "loki.serviceName"
    value = "loki"
  }
}
