output "connection_info" {
  value = {
    name      = module.this.name
    namespace = var.namespace
    fqdn      = "${module.this.name}.${var.namespace}.svc.cluster.local"
    url       = "http://${module.this.name}.${var.namespace}.svc.cluster.local:8080"
  }
}
