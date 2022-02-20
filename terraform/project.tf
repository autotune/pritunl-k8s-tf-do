resource "digitalocean_project" "atlantis" {
  name        = "atlantis"
  description = "Sets up atlantis on DigitalOcean"
  environment = "Production"

  resources = [
    digitalocean_kubernetes_cluster.k8s.urn[0]
  ]
}
