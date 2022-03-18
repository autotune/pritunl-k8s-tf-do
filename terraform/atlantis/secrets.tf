resource "kubernetes_secret" "docker_login_secret" {
  metadata {
    name      = "${replace(var.domain_name, ".", "-")}-docker-login"
    namespace = "pritunl"
  }

  data = {
      ".dockerconfigjson": data.template_file.docker_registry.rendered
  }

  type = "kubernetes.io/dockerconfigjson" 
}
