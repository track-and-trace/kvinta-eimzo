module "this" {
  source  = "terraform.kvinta.io/kvinta/application/k8s"
  version = "3.2.4"

  wait_for_rollout = false

  name      = "eimzo"
  namespace = var.namespace

  enabled           = var.enabled
  replicas          = var.replicas
  java_opts         = var.java_opts
  resources_options = var.resources_options

  image_registry    = var.image_registry
  image_repo        = "apps/eimzo"
  image_tag         = var.image_tag
  image_pull_policy = var.image_pull_policy

  envs = merge(
    {
      KVINTA_UZ_EIMZO_CONTAINERS_NAME                = var.eimzo_enable ? lookup(var.eimzo_config, "name") : null
      KVINTA_UZ_EIMZO_CONTAINERS_CRYPTOCONTAINERPATH = var.eimzo_enable ? "/app/eimzo/key-file.pfx" : null
      eimzo_checksum                                 = md5(yamlencode(var.eimzo_config))
    },
    var.envs,
  )

  sensitive_envs = { for k, v in merge({
    KVINTA_UZ_EIMZO_CONTAINERS_PASSWORD = var.eimzo_enable ? lookup(var.eimzo_config, "password") : null
    }, var.sensitive_envs,
  ) : (k) => v if v != null }


  vols_secrets = [
    {
      name       = kubernetes_secret.eimzo_data[0].metadata.0.name
      mount_path = "/app/secrets/eimzo"
    }
  ]

  vols_configmaps = [
    {
      name       = kubernetes_config_map.eimzo_init_container.metadata[0].name
      mount_path = "/app/init-scripts/"
      mode       = "0700"
    }
  ]

  vols_shared = [
    {
      name       = "eimzo-keys"
      mount_path = "/app/eimzo"
    }
  ]

  busybox_init_containers = [
    {
      name    = "init-container"
      command = ["sh", "/app/init-scripts/init_container.sh"]
    }
  ]

  probes_enabled = var.probes_enabled
  probes_options = var.probes_options

  logging_enabled = var.logging_enabled
  logging_format  = var.logging_format
  logging_levels  = merge({ "kvinta.uz.eimzo" = "INFO" }, var.logging_levels)

  app_version   = var.this_version
  stack_name    = var.stack_name
  stack_version = var.stack_version
  cloud_name    = var.cloud_name
  cloud_version = var.cloud_version
}

resource "kubernetes_config_map" "eimzo_init_container" {
  metadata {
    name      = "eimzo-init-container"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"    = "eimzo"
      "app.kubernetes.io/version" = var.image_tag
    }
  }

  data = {
    "init_container.sh" = <<-SH
      #!/usr/bin/env bash

      set -e

      echo "Preparing Eimzo container files"

      mkdir -p /app/eimzo

      for filename in key-file.pfx; do
        final_name="/app/eimzo/$${filename}"
        echo "Storing $${final_name}"
        if [ -f /app/secrets/eimzo/$${filename} ]; then
          base64 -d /app/secrets/eimzo/$${filename} > "$${final_name}"
        else
          echo "Can't find file /app/secrets/eimzo/$${filename}"
          echo "Printing all possible files:"
          find /app/secrets/eimzo/
          exit 1
        fi
      done

      chmod -R u=rx,go-rwx /app/eimzo

      echo "Done"
    SH
  }
}
