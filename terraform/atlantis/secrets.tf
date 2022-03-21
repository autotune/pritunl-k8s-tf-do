resource "kubernetes_secret" "docker_login_secret" {
  metadata {
    name      = "${replace(var.domain_name, ".", "-")}-docker-login"
    namespace = "pritunl"
  }

  data = {
      ".dockerconfigjson": <<EOF
{
  "auths": {
    "ghcr.io": {
      "auth": "${local.docker_secret_encoded}"
    }
  }
}
EOF
  }
}

  type = "kubernetes.io/dockerconfigjson" 
}
