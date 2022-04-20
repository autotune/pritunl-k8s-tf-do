# pritunl-k8s-tf-do

## What does it do? 

Starts out using GitHub Actions to launch Atlantis via Terraform 

Uses Terraform to launch a kubernetes cluster in Digital Ocean with zerossl.com (a LetsEncrypt alternative with many pros including paid support, paid 1 year certs, free 90 day certs, and visibility into created certs) 

Creates a deployment with ingress for atlantis at `https://terraform.example.com`


Creates a deployment using mongodb helm chart 

Creates a deployment using heavily customized pritunl helm chart

Creates ingress to pritunl deployment at `https://pritunl.example.com`

See pritunl documentation for obtaining admin credentials after doing an `exec` into a pritunl pod. 

## How to use?

* Create a DigitalOcean account with your own custom domain. 

* Fork the repo. 

* Generate each secret for use in your own accounts. Change the `domain_name` var in terraform to your own domain hosted in DigitalOcean.  

* Run the initial build with GitHub Actions to create atlantis deployment 

* Once atlantis is launched, you go into the `terraform/atlantis` subfolder and create a PR with a small change. Could be as simple as an added "foo" variable. Then comment with `atlantis apply` once plan is complete.
 

## Why zerossl?

In addition to that the lack of customer service, lack SLA, and inability to upgrade to a paid plan, the rate limits are just far too low relative to other ACME providers out there. In my controversial opinion LetsEncrypt has its use cases but was not ideal for this project. 

DigiCert docs for certmanager: https://knowledge.digicert.com/solution/Configure-cert-manager-and-DigiCert-ACME-service-with-Kubernetes.html 

zerossl rate limit policies (unlimited): https://zerossl.com/letsencrypt-alternative

## OAUTH2

Installed the oauth2-proxy helm chart and created ingress rules outside of that to get it working with Atlantis. 

## MONGODB 

Uses official mongodb helm chart. User management bit of a plaintext nightmare with official chart so created a python script (mongo\_add\_user.py) to connect to db and add user. 

## PRITUNL

Uses https://github.com/articulate/helmcharts/tree/master/stable/pritunl as base. I manually created ingress helm template and made several modifications to get working with a generic, non-AWS, deployment. 

## SECRETS

ATLANTIS\_GH\_TOKEN

ATLANTIS\_GH\_USER

AWS\_ACCESS\_KEY\_ID

AWS\_SECRET\_ACCESS\_KEY

DOMAIN\_NAME

DO\_TOKEN

GH\_USERNAME

LETSENCRYPT\_EMAIL

MONGODB\_ROOT\_PASSWORD

OAUTH\_CLIENT\_ID

OAUTH\_CLIENT\_SECRET

OAUTH\_COOKIE\_SECRET

PACKAGE\_REGISTRY\_PAT

SSLCOM\_HMAC\_KEY

SSLCOM\_KEYID

SSLCOM\_PRIVATE\_KEYID