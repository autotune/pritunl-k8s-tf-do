locals {
  name      = "${var.do_k8s_name}"
  gh_ips    = [
    for h in data.github_ip_ranges.default.git_ipv4 : h if length(split(":", h)) == 1
  ] 
}
