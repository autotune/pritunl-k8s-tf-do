resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"  
  }
}


resource "helm_release" "mongodb" {
  name       = "pritunl-mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "pritunl" 
  version    = var.mongodb_version

  values   = [ sensitive(data.template_file.mongodb.rendered) ] 
}
