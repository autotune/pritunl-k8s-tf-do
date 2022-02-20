resource "kubernetes_deployment" "sample_deployments" {
  for_each = toset(var.domain_name)
  metadata {
    name = "${replace(each.value, ".", "-")}-deployment"
    namespace="default"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "${replace(each.value, ".", "-")}-deployment"
      }
    }
    template {
      metadata {
        labels = {
          app  = "${replace(each.value, ".", "-")}-deployment"
        }
      }
      spec {
        container {
          image = "nginxdemos/hello"
          name  = "nginx-hello"
          port {
            container_port = 80
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

resource "kubernetes_service" "sample_services" {
  for_each = toset(var.domain_name)
  metadata {
    name      = "${replace(each.value, ".", "-")}-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "${replace(each.value, ".", "-")}-deployment"
    }
    port {
      port = 80
    }
  }
}

resource "kubernetes_deployment" "atlantis_deployments" {
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
