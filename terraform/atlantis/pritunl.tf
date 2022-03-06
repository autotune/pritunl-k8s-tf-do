resource "kubernetes_namespace" "pritunl" {
  metadata {
    name = "pritunl"
  }
}
