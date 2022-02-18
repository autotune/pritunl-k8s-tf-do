#!/usr/bin/env bash

function check_deps() {
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
  test -f $(which curl) || error_exit "curl command not detected in path, please install it"
}

function parse_input() {
  eval "$(jq -r '@sh "export TOKEN=\(.do_token)"')"
  if [[ -z "${TOKEN}" ]]; then export TOKEN=none; fi
}

function return_version() {
  VERSION=$(curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/kubernetes/options" | jq .options.versions | jq 'values[0]' | jq -r .slug)
  jq -n \
    --arg version "$VERSION" \
    '{"version":$version}'
}

check_deps && \
parse_input && \
sleep 2 && \
return_version
