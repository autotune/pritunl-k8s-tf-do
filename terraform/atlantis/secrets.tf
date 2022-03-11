resource "kubernetes_secret" "docker_login_secret" {
  for_each = toset(var.domain_name)
  metadata {
    name      = "${replace(each.key, ".", "-")}-docker-login"
    namespace = "oauth-proxy"
  }

  data = {
      dockerconfigjson = sensitive(data.template_file.docker_registry.rendered)
  }

  type = "kubernetes.io/opaque"
}
