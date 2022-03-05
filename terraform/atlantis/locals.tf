locals {
  name        = "${var.do_k8s_name}"
  domain_name = "${replace(${var.domain_name[0], ".", "-")}"
}
