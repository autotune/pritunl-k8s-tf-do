service:
  annotations: {}

image:
  registry: ${DOCKER_REGISTRY}  
  repository: autotune/pritunl-k8s-tf-do/autotune/pritunl-k8s-tf-do
  tag: ${DOCKER_TAG} 
  pullPolicy: Always
  pullSecret: "${DOMAIN_NAME}-docker-login"
  domainName: "${DOMAIN_NAME_VERBOSE}"
  secretName: "${DOMAIN_NAME}-pritunl-tls"

# This should match whatever the 'mongodb' service is called in the cluster.
# DNS should be able to resolve the service by this name for Pritunl to function.
mongoService: "pritunl-mongodb"

# Change these as you see fit.
ports:
  http: 80
  vpn: 1194
  webui: 80 

# This must be enabled when using Pritunl due to the rights that iptables will need in the Pritunl pods.
privileged:
  enabled: true

# This will adjust the replicas that are deployed as a part of the Pritunl deployment.
# This is '3' by default. Your Pritunl cluster number will be affected by this.
replicaCount: 3

tty:
  enabled: true

# Health Checks
livenessProbe:
  enabled: true
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 6
  successThreshold: 1

readinessProbe:
  enabled: true
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 6
  successThreshold: 1
