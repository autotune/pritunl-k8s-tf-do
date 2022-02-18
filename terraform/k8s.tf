resource "random_id" "cluster_name" {
  count       = var.enable_digitalocean ? 1 : 0
  byte_length = 6
}

data "external" "get_latest_do_k8s_version" {
  count   = var.enable_digitalocean ? 1 : 0
  program = ["sh", "${path.module}/get_do_latest_k8s_version.sh"]

  query = {
    do_token = var.do_token
  }
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  count   = var.enable_digitalocean ? 1 : 0
  name    = "${var.do_k8s_name}-${random_id.cluster_name[count.index].hex}"
  region  = var.do_region
  version = data.external.get_latest_do_k8s_version[count.index].result["version"]

  node_pool {
    name       = var.do_k8s_pool_name
    size       = var.do_k8s_node_type
    node_count = var.do_k8s_nodes
  }
}

resource "digitalocean_kubernetes_node_pool" "k8s_nodes" {
  count      = var.enable_digitalocean ? 1 : 0
  cluster_id = digitalocean_kubernetes_cluster.k8s[count.index].id

  name       = var.do_k8s_nodepool_name
  size       = var.do_k8s_nodepool_type
  node_count = var.do_k8s_nodepool_size
}

resource "local_file" "kubeconfigdo" {
  count    = var.enable_digitalocean ? 1 : 0
  content  = digitalocean_kubernetes_cluster.k8s[count.index].kube_config[0].raw_config
  filename = "${path.module}/kubeconfig_do"
}
