# pritunl chart based off of https://github.com/articulate/helmcharts/tree/master/stable/pritunl

resource "kubernetes_namespace" "pritunl" {
  metadata {
    name = "pritunl"
  }
}

resource "helm_release" "pritunl" {
  depends_on = [kubernetes_namespace.pritunl, kubernetes_namespace.mongodb]

  name       = "pritunl"
  repository = "./helm_charts"
  chart      = "pritunl"
  namespace  = "pritunl"
  version    = "0.0.1" 

  values   = [ data.template_file.pritunl.rendered ]
}
