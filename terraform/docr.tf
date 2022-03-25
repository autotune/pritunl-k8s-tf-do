resource "digitalocean_container_registry" "pritunl" {
  name                   = "pritunl"
  subscription_tier_slug = "starter"
}
