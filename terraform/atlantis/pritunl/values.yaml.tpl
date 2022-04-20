image:
  registry: ${DOCKER_REGISTRY}  
  repository: autotune/pritunl-k8s-tf-do/autotune/pritunl-k8s-tf-do
  tag: ${DOCKER_TAG} 
  pullPolicy: Always
  pullSecret: "${DOMAIN_NAME}-docker-login"
  domainname: "${DOMAIN_NAME}"
  secretname: "${DOMAIN_NAME}-pritunl-tls"
