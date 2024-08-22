variable "artifact_registry_configs" {
  type = object({
    repositories = map(object({
      repository_id = string
      labels        = map(string)
      mode          = string
      project_id    = string
      format        = string
      location      = string
      description   = optional(string, "")
    }))
  })
}

variable "iam_configs" {
  description = "IAM Configurations"
  type = object({
    iam_role_bindings = map(object({
      project_id            = string
      service_account_email = string
      roles                 = list(string)
    }))
  })
}

variable "gke_configs" {
  type = object({
    clusters = map(object({
      name                       = string
      project_id                 = string
      region                     = string
      zones                      = list(string)
      network                    = string
      subnetwork                 = string
      network_project_id         = string
      ip_range_pods              = string
      ip_range_services          = string
      master_ipv4_cidr_block     = string
      kubernetes_version         = string
      release_channel            = optional(string, "STABLE")
      http_load_balancing        = optional(bool, false)
      horizontal_pod_autoscaling = optional(bool, true)
      network_policy             = optional(bool, false)
      filestore_csi_driver       = optional(bool, false)
      enable_private_endpoint    = optional(bool, true)
      enable_private_nodes       = optional(bool, true)
      deletion_protection        = optional(bool, false)
      config_connector           = optional(bool, false)
      enable_fleet_registration  = optional(bool, false)
      enable_policy_controller   = optional(bool, false)
      enable_fleet_feature       = optional(bool, false)
      enable_config_sync         = optional(bool, false)
      config_sync_install_repo   = optional(string, "us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod/oci/config-sync-init:0.1")
      service_account_name       = optional(string)
      create_service_account     = optional(bool, true)
      config_mgmt_version        = optional(string, "1.18.0")
      master_authorized_networks = optional(list(object({ cidr_block = string, display_name = string })), [])
      fleet_membership_name      = optional(string)
      node_pools = optional(list(map(any)), [
        {
          name = "default-node-pool"
        }
      ])
      node_pools_oauth_scopes = optional(map(list(string)), {
        all               = ["https://www.googleapis.com/auth/cloud-platform"]
        default-node-pool = []
      })
      node_pools_labels = optional(map(map(string)), {
        all               = {}
        default-node-pool = {}
      })
      node_pools_metadata = optional(map(map(string)), {
        all               = {}
        default-node-pool = {}
      })
      node_pools_taints = optional(map(list(object({ key = string, value = string, effect = string }))), {
        all               = []
        default-node-pool = []
      })
      node_pools_tags = optional(map(list(string)), {
        all               = []
        default-node-pool = []
      })
    }))
  })
}

variable "gke_resources" {
  description = "GKE resources"
}

