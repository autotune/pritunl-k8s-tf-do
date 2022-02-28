resource "helm_release" "oauth2_proxy" {
  name       = "oauth2-proxy"

  repository = "https://oauth2-proxy.github.io/manifests"
  chart      = "oauth2-proxy"

  set {
    name  = "config.clientID"
    value = "${var.oauth_client_id}"
  }

  set {
    name  = "config.clientSecret"
    value = "${var.oauth_client_secret}"
  }

  set {
    name  = "config.cookieSecret"
    value = "${var.oauth_cookie_secret}"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.path"
    value = "/oauth2"
  }

  set {
    name  = "ingress.hosts"
    value = "[${var.domain_name}]"
  }

  set {
    name  = "ingress.annotations"
    value = "[ kubernetes.io/ingress.class: nginx, kubernetes.io/tls-acme: \"true\", 
             cert-manager.io/cluster-issuer: \"zerossl\"]" 
  }
}

resource "kubernetes_deployment" "atlantis_deployments" {

  depends_on = [digitalocean_kubernetes_cluster.k8s, kubernetes_namespace.oauth_proxy]

  for_each = toset(var.domain_name)
  metadata {
    name = "${replace(each.value, ".", "-")}-atlantis-deployment"
    namespace="atlantis"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "${replace(each.value, ".", "-")}-atlantis-deployment"
      }
    }
    template {
      metadata {
        labels = {
          app  = "${replace(each.value, ".", "-")}-atlantis-deployment"
        }
      }
      spec {
        container {
          image   = var.atlantis_container
          name    = "atlantis"
          command = ["atlantis", "server"] 

          port {
            name           = "atlantis"
            container_port = 80 
            protocol       = "TCP"
          }

          env {
            name  = "ATLANTIS_LOG_LEVEL"
            value = "debug"
          }

          env {
            name  = "ATLANTIS_PORT"
            value = "80"
          }

          env {
            name  = "ATLANTIS_ATLANTIS_URL"
            value = "https://${each.value}"
          }

          env {
            name  = "ATLANTIS_GH_USER"
            value = var.atlantis_github_user
          }

          env {
            name  = "ATLANTIS_GH_TOKEN"
            value = var.atlantis_github_user_token
          }

          env {
            name  = "ATLANTIS_GH_WEBHOOK_SECRET"
            value = random_id.webhook.hex
          }

           env {
            name  = "ATLANTIS_REPO_WHITELIST"
            value = var.atlantis_repo_whitelist
          }

          resources {
            limits = {
              memory = "512M"
              cpu = "1"
            }
            requests = {
              memory = "256M"
              cpu = "50m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "atlantis" {

  depends_on = [digitalocean_kubernetes_cluster.k8s]

  for_each = toset(var.domain_name)
  metadata {
    name      = "${replace(each.value, ".", "-")}-atlantis-service"
    namespace = "atlantis"
  }
  spec {
    selector = {
      app = "${replace(each.value, ".", "-")}-atlantis-deployment"
    }
    port {
      port = 80 
    }
  }
}
