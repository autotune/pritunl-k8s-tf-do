locals {
  name      = "${var.do_k8s_name}"
  gh_ips    = [
    for h in data.github_ip_ranges.default.hooks : h if length(split(":", h)) == 1, "10.0.0.0/16"
  ] 
}
