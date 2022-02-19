locals {
  name      = "${var.do_k8s_name}-${random_id.cluster_name[1]}"
}
