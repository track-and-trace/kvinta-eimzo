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
      EIMZO_CONFIGS_FILE_PATH = "/app/eimzo-configs/configs.yml"
      eimzo_checksum          = md5(yamlencode(var.eimzo_config))
      init_checksum           = local.eimzo_init_container_script_checksum
    },
    var.envs,
  )

  sensitive_envs = { for k, v in merge({
    }, var.sensitive_envs,
  ) : (k) => v if v != null }


  vols_secrets = [
    {
      name       = kubernetes_secret.eimzo_data.metadata.0.name
      mount_path = "/app/eimzo-configs"
    },
    {
      name       = kubernetes_secret.eimzo_keys.metadata.0.name
      mount_path = "/app/eimzo-keys-data"
    }
  ]

  vols_shared = [{
    name       = "eimzo-keys-data"
    mount_path = "/app/eimzo-keys"
  }]

  vols_configmaps = [{
    name       = kubernetes_config_map.eimzo_init_container.metadata.0.name
    mount_path = "/app/init-scripts/"
    mode       = "0700"
  }]

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


locals {
  eimzo_init_container_script          = <<-SH
      #!/usr/bin/env bash

      set -e

      echo "Preparing Eimzo container files"

      for filename in ${local.eimzo_keys_files}; do
        src_file_base64="/app/eimzo-keys-data/$filename"
        dst_file=$(echo "/app/eimzo-keys/$filename" | sed 's/\.pfx\.base64/.pfx/')

        echo "Unpacking '$src_file_base64' to '$dst_file'"
        if [ -f $src_file_base64 ]; then
          touch $dst_file # test if dest is writable
          base64 -d $src_file_base64 > $dst_file
        else
          echo "Can't find file $src_file_base64"
          echo "Printing all possible files:"
          ls -l /app/eimzo-keys-data
          exit 1
        fi
      done

      chmod -R u=rx,go-rwx /app/eimzo-keys

      echo "Done"

      echo "DEBUG:"
      echo "EIMZO_CONFIGS_FILE_PATH=$EIMZO_CONFIGS_FILE_PATH"
      echo "EIMZO_CONFIGS_FILE_PATH:"
      cat $EIMZO_CONFIGS_FILE_PATH
    SH
  eimzo_init_container_script_checksum = md5(local.eimzo_init_container_script)
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
    "init_container.sh" = local.eimzo_init_container_script
  }
}
