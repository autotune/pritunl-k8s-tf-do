resource "random_string" "random" {
  length           = 16
  special          = true
}

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

resource "kubernetes_secret" "oath_proxy_secret" {
  metadata {
    name      = "oath_proxy_secret"
    namespace = "oath-proxy"
  }

  data = {
      github-client-id = base64encode(var.oath_client_id)
      github-client-secret: base64encode(var.oath_client_secret)
      cookie-secret: base64encode(random_string.random.result)
  }

  type = "kubernetes.io/opaque"
}
