resource "digitalocean_project" "atlantis" {
  name        = "atlantis"
  description = "Sets up atlantis on DigitalOcean"
  environment = "Production"
}
