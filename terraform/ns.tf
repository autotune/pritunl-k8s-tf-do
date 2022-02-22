resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

resource "kubernetes_namespace" "oath_proxy" {
  metadata {
    name = "oath-proxy"
  }
}
