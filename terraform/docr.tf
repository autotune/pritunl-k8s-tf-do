resource "digitalocean_container_registry" "default" {
  name                   = "default"
  subscription_tier_slug = "starter"
}
