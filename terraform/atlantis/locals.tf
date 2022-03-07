locals {
  name                  = "${var.do_k8s_name}"
  docker_secret         = "${var.gh_username}:${var.package_registry_pat}" 
  docker_secret_encoded = base64encode(docker_secret)
}
