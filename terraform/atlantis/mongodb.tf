resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"  
  }
}

resource "helm_release" "mongodb" {
  depends_on = [kubernetes_namespace.mongodb]

  name       = "pritunl-mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "pritunl" 
  version    = var.mongodb_version

  # values   = [ sensitive(data.template_file.mongodb.rendered) ] 
  provisioner "remote-exec" {
    inline = [
      "chmod +x mongodb/create_user.sh",
      "mongodb/create_user.sh",
    ]
}
