# based off of https://github.com/anarkioteam/terraform-helm-argocd

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"  
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd" 
  version    = var.argocd_helm_chart_version == "" ? null : var.argocd_helm_chart_version

  values = [
    data.template_file.argocd  
  ]
}
