resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}
