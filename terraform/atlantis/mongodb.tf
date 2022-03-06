resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mondodb"  
  }
}

resource "helm_release" "mongodb" {
  depends_on = [kubernetes_namespace.mongodb]

  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "mongodb" 
  version    = var.mongodb_version

  # values   = [ sensitive(data.template_file.mongodb.rendered) ] 
}
