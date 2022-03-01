locals {
  name      = "${var.do_k8s_name}"
  gh_ips    =  [for range in data.github_ip_ranges.default.hooks : 
cidrhost(range, 0)]
}
