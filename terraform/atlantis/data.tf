data "template_file" "pritunl" {
  template = file("${path.module}/pritunl/values.yaml.tpl")
  vars = {
    DOMAIN_NAME     = replace(var.domain_name, ".", "-")
    DOCKER_REGISTRY = "${var.gh_username}/pritunl-k8s-tf-do"
    DOCKER_TAG      = "a9661a1a"
  }
}

data "template_file" "docker_registry" {
  template = "${path.module}/docker/values.yaml.tpl"

  vars ={ 
    docker_secret_encoded = base64encode(local.docker_secret_encoded)
  }
}

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
