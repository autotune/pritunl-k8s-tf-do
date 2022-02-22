resource "kubernetes_secret" "eab_hmac" {
  metadata {
    name = "sslcom-hmac-key"
  }

  data = {
    secret = base64encode(var.sslcom_hmac_key)
  }

  type = "kubernetes.io/opaque"
}
