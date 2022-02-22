resource "kubernetes_secret" "eab_hmac" {
  metadata {
    name      = "sslcom-hmac-key"
    namespace = "kube-system"
  }

  data = {
    secret = var.sslcom_hmac_key
  }

  type = "kubernetes.io/opaque"
}
