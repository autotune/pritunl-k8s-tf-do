locals {
  name                  = "${var.do_k8s_name}"
  docker_secret         = "${var.gh_username}:${var.package_registry_pat}" 
  extra_ips             = ["167.71.252.152", "138.197.48.247"]
  docker_secret_encoded = base64encode(local.docker_secret)
  docker-credentials = {
    auths = {
      "ghcr.io" = {
        auth = base64encode("${var.gh_username}:${var.package_registry_pat}")
      }
    }
  }
}
