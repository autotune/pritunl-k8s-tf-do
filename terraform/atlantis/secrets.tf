resource "kubernetes_secret" "docker_login_secret" {
  metadata {
    name      = "${replace(var.domain_name, ".", "-")}-docker-tls"
    namespace = "pritunl"
  }

  data = {
      dockerconfigjson = base64encode(sensitive(data.template_file.docker_registry.rendered))
  }

  type = "kubernetes.io/opaque"
}
