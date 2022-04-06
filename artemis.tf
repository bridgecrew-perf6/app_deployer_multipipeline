module "artemis-terraform-helm" {
  source               = "./modules/terraform-helm/"
  deployment_name      = "artemis"
  deployment_namespace = var.namespace
  deployment_path      = "charts/artemis/"
  values_yaml          = <<EOF

image:
  repository: "${var.image}"
  tag: "${var.tag}"

imagePullSecrets:
  - name: regcred

service:
  type: ClusterIP
  port: 5000

ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "64m"
    ingress.kubernetes.io/ssl-redirect: "false"
    cert-manager.io/cluster-issuer: letsencrypt-prod
    acme.cert-manager.io/http01-edit-in-place: "true"
    kubernetes.io/ingress.class: nginx
  hosts:
  - host: "artemis-${var.namespace}.${var.google_domain_name}"
    paths: 
    - path: /
  tls: 
  - secretName: artemis
    hosts:
    - "artemis-${var.namespace}.${var.google_domain_name}"
  ingressClassName: nginx
  EOF
}
