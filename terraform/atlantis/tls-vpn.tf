resource "kubernetes_secret" "tls-vpn" {
  depends_on = [kubernetes_namespace.pritunl]
  metadata {
    name      = "${replace(var.domain_name, ".", "-")}-vpn-tls"
    namespace = "pritunl"
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.cert-vpn.cert_pem
    "tls.key" = tls_private_key.key-vpn.private_key_pem
  }
}

resource "tls_private_key" "ca-vpn" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "ca-vpn" {
  key_algorithm   = tls_private_key.ca-vpn.algorithm
  private_key_pem = tls_private_key.ca-vpn.private_key_pem

  subject {
    common_name  = "ca.local"
    organization = "Pritunl"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "digital_signature",
    "key_encipherment",
  ]

  provisioner "local-exec" {
    command = "echo '${self.cert_pem}' > ../tls/ca.pem && chmod 0600 ../tls/ca.pem"
  }
}

resource "tls_private_key" "key-vpn" {
  algorithm = "RSA"
  rsa_bits  = "2048"

  provisioner "local-exec" {
    command = "echo '${self.private_key_pem}' > ../tls/tls.key && chmod 0600 ../tls/tls.key"
  }
}

resource "tls_cert_request" "request-vpn" {
  key_algorithm   = tls_private_key.key-vpn.algorithm
  private_key_pem = tls_private_key.key-vpn.private_key_pem

  dns_names = [
    "atlantis",
    "atlantis.local",
    "atlantis.default.svc.cluster.local",
    "localhost",
    "vpn.${var.domain_name}",
  ]

  ip_addresses = [
    "127.0.0.1",
    data.digitalocean_loadbalancer.default.ip,
  ]

  subject {
    common_name  = "vpn.${var.domain_name}"
    organization = "Atlantis"
  }
}

resource "tls_locally_signed_cert" "cert-vpn" {
  cert_request_pem = tls_cert_request.request-vpn.cert_request_pem

  ca_key_algorithm   = tls_private_key.ca-vpn.algorithm
  ca_private_key_pem = tls_private_key.ca-vpn.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca-vpn.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "cert_signing",
    "client_auth",
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]

  provisioner "local-exec" {
    command = "echo '${self.cert_pem}' > ../tls/tls.cert && echo '${tls_self_signed_cert.ca-vpn.cert_pem}' >> ../tls/tls.cert && chmod 0600 ../tls/tls.cert"
  }
}
