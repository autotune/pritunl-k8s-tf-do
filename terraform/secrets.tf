resource "kubernetes_secret" "eab_hmac" {
  metadata {
    name = "sslcom-hmac-key"
  }

  data = {
    secret = base64encode(var.sslcom_hmac_key)
  }

  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "private_eab_hmac" {
  metadata {
    name = "sslcom-private-hmac-key"
  }

  data = {
    secret = base64encode(var.sslcom_private_hmac_key)
  }

  type = "kubernetes.io/opaque"
}
