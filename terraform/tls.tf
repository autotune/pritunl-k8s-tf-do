resource "kubernetes_secret" "tls" {
  for_each = toset(var.domain_name)
  metadata {
    name      = "${replace(each.value, ".", "-")}-atlantis-tls"
    namespace = "atlantis"
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.cert[each.key].cert_pem
    "tls.key" = tls_private_key.key[each.key].private_key_pem
  }
}

resource "random_id" "encryption-key" {
  byte_length = "32"
}

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "ca" {
  for_each = toset(var.domain_name)
  key_algorithm   = tls_private_key.ca[each.key].algorithm
  private_key_pem = tls_private_key.ca[each.key].private_key_pem

  subject {
    common_name  = "ca.local"
    organization = "Atlantis"
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

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = "2048"

  provisioner "local-exec" {
    command = "echo '${self.private_key_pem}' > ../tls/tls.key && chmod 0600 ../tls/tls.key"
  }
}

resource "tls_cert_request" "request" {
  for_each = toset(var.domain_name)
  key_algorithm   = tls_private_key.key.algorithm
  private_key_pem = tls_private_key.key.private_key_pem

  dns_names = [
    "atlantis",
    "atlantis.local",
    "atlantis.default.svc.cluster.local",
    "localhost",
    "${each.value}",
  ]

  ip_addresses = [
    "127.0.0.1",
    digitalocean_loadbalancer.ingress_load_balancer.ip,
  ]

  subject {
    common_name  = "wayofthesys.com"
    organization = "Atlantis"
  }
}

resource "tls_locally_signed_cert" "cert" {
  for_each = toset(var.domain_name)
  cert_request_pem = tls_cert_request.request[each.key].cert_request_pem

  ca_key_algorithm   = tls_private_key.ca[each.key].algorithm
  ca_private_key_pem = tls_private_key.ca[each.key].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[each.key].cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "cert_signing",
    "client_auth",
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]

  provisioner "local-exec" {
    command = "echo '${self.cert_pem}' > ../tls/tls.cert && echo '${tls_self_signed_cert.ca[each.key].cert_pem}' >> ../tls/tls.cert && chmod 0600 ../tls/tls.cert"
  }
}
