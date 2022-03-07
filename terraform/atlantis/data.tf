/* 
data "template_file" "argocd" {
  template = "${path.module}/mongodb/values.yaml.tpl"
  vars = {
        argocd_server_host          = "argocd.${var.domain_name}"  
        argocd_github_client_id     = var.oauth_client_id
        argocd_github_client_secret = var.oauth_client_secret

        argocd_ingress_enabled                 = var.argocd_ingress_enabled
        argocd_ingress_tls_acme_enabled        = var.argocd_ingress_tls_acme_enabled
        argocd_ingress_ssl_passthrough_enabled = var.argocd_ingress_ssl_passthrough_enabled
        argocd_ingress_class                   = var.argocd_ingress_class
        argocd_ingress_tls_secret_name         = "${var.domain_name}-argocd-tls"
  }
}
*/

data "digitalocean_kubernetes_cluster" "k8s" {
  name = local.name
}

provider "kubernetes" {
  host                   = data.digitalocean_kubernetes_cluster.k8s.endpoint
  token                  = data.digitalocean_kubernetes_cluster.k8s.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host                   = data.digitalocean_kubernetes_cluster.k8s.endpoint
    token                  = data.digitalocean_kubernetes_cluster.k8s.kube_config[0].token

    cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
    )
  }
}

data "digitalocean_loadbalancer" "default" {
  name = "${var.do_k8s_name}-lb"
}
