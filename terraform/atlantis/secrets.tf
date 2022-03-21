resource "kubernetes_secret" "docker_login_secret" {
  metadata {
    name      = "${replace(var.domain_name, ".", "-")}-docker-login"
    namespace = "pritunl"
  }

  data = {
      ".dockerconfigjson": jsonencode(local.docker-credentials)
  }

  type = "kubernetes.io/dockerconfigjson" 
}
