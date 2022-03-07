# pritunl chart based off of https://github.com/articulate/helmcharts/tree/master/stable/pritunl

resource "kubernetes_namespace" "pritunl" {
  metadata {
    name = "pritunl"
  }
}


