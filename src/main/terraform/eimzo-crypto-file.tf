resource "kubernetes_secret" "eimzo_data" {
  count = var.eimzo_enable ? 1 : 0

  metadata {
    name      = "eimzo-crypto-data"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"    = "eimzo"
      "app.kubernetes.io/version" = var.image_tag
    }
  }

  data = {
    "key-file.pfx" = var.eimzo_enable ? lookup(var.eimzo_config, "files/key-file.pfx") : null
  }
}
