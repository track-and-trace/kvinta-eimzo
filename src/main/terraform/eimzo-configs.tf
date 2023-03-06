resource "kubernetes_secret" "eimzo_data" {
  metadata {
    name      = "eimzo-configs"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"    = "eimzo"
      "app.kubernetes.io/version" = var.image_tag
    }
  }

  data = {
    "configs.yml" = yamlencode({
      kvinta = {
        uz = {
          eimzo = {
            containers = { for name, info in var.eimzo_config : (name) => {
              "cryptoContainerPath" = "/app/eimzo-keys/${name}-key-file.pfx"
              "password"            = lookup(info, "password")
              }
            }
          }
        }
      }
    })
  }
}

resource "kubernetes_secret" "eimzo_keys" {
  metadata {
    name      = "eimzo-keys"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"    = "eimzo"
      "app.kubernetes.io/version" = var.image_tag
    }
  }

  data = { for name, info in var.eimzo_config : "${name}-key-file.pfx.base64" => lookup(info, "files/key-file.pfx.base64") }
}

locals {
  eimzo_keys_files = join(" ", [for name, info in var.eimzo_config : "${name}-key-file.pfx.base64"])
}
