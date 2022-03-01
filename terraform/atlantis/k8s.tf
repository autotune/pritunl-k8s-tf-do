data "digitalocean_kubernetes_cluster" "k8s" {
  name = var.do_k8s_name 
}

provider "kubernetes" {
  host                   = data.digitalocean_kubernetes_cluster.k8s[0].endpoint
  token                  = data.digitalocean_kubernetes_cluster.k8s[0].kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s[0].kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host                   = data.digitalocean_kubernetes_cluster.k8s[0].endpoint
    token                  = data.digitalocean_kubernetes_cluster.k8s[0].kube_config[0].token

    cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s[0].kube_config[0].cluster_ca_certificate
    )
  }
}

