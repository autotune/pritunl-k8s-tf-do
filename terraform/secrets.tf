resource "kubernetes_secret" "eab_hmac" {
  metadata {
    name      = "sslcom-hmac-key"
    namespace = "kube-system"
  }

  data = {
    secret = base64encode(var.sslcom_hmac_key)
  }

  type = "kubernetes.io/opaque"
}
