resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

resource "kubernetes_namespace" "oath-proxy" {
  metadata {
    name = "oath-proxy"
  }
}
