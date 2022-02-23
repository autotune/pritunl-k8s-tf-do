resource "kubernetes_deployment" "oauth_deployments" {

  depends_on = [digitalocean_kubernetes_cluster.k8s] 

  for_each = toset(var.domain_name)
  metadata {
    name = "${replace(each.value, ".", "-")}-oauth2-deployment"
    namespace="oauth-proxy"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "${replace(each.value, ".", "-")}-oauth2-deployment"
      }
    }
    template {
      metadata {
        labels = {
          app  = "${replace(each.value, ".", "-")}-oauth2-deployment"
        }
      }
      spec {
        container {
          image = "quay.io/pusher/oauth2_proxy:latest"
          name  = "oauth2-proxy"
          args  = ["--provider=digitalocean", "--email-domain=contrasting.org", "--upstream=file:///dev/null",
                   "--http-address=0.0.0.0:4180", "--whitelist-domain=auth.${each.key}", 
                   "--cookie-domain=auth.${each.key} --redirect-url=https://${each.key}/oauth2/callback"]
          port {
            container_port = 4180
          }

          env { 
              name       = "OAUTH2_PROXY_CLIENT_ID"
              value_from {
                secret_key_ref {
                  name = "${replace(each.key, ".", "-")}-oauth-proxy-tls"
                  key  = "github-client-id"
                 }
               }
           }
          env {
               name       = "OAUTH2_PROXY_CLIENT_SECRET"
               value_from {
                 secret_key_ref {
                   name = "${replace(each.key, ".", "-")}-oauth-proxy-tls"
                   key  = "github-client-secret"
                 }
               }
           }
          env {
              name       = "OAUTH2_PROXY_COOKIE_SECRET"
              value_from {
                secret_key_ref {
                  name = "${replace(each.key, ".", "-")}-oauth-proxy-tls"
                  key  = "cookie-secret"
                }
              }
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

resource "kubernetes_service" "oauth_services" {

  depends_on = [digitalocean_kubernetes_cluster.k8s]

  for_each = toset(var.domain_name)
  metadata {
    name      = "${replace(each.value, ".", "-")}-oauth2-service"
    namespace = "oauth-proxy"
  }
  spec {
    selector = {
      app = "${replace(each.value, ".", "-")}-oauth2-deployment"
    }
    port {
      port        = 4180
      target_port = 4180
    }
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
            value = "https://atlantis.${each.value}"
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
