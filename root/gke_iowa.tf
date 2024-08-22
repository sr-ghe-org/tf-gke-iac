/*
  DEPLOYMENT STEPS : 

  1. Cluster Creation: Builds the GKE clusters.
  2. Provider & Namespace: Configures the Kubernetes provider and creates namespaces for resource organization.
  3. Controller Deployment: Deploy controllers to manage the system.
  4. Secrets Creation: Securely stores sensitive configuration data.
  5. Resource Deployment: Deploy the actual application components (runner sets, agent pools, etc.).
*/

# locals {
#   gke_iowa_controller_manifests     = { for k, v in var.gke_resources.clusters.gke_iowa.manifests : k => v if v.controller == true }
#   gke_iowa_non_controller_manifests = { for k, v in var.gke_resources.clusters.gke_iowa.manifests : k => v if v.controller == false }
# }

# resource "google_service_account" "gke_gar_sa" {
#   project    = var.gke_configs.clusters.gke_iowa.project_id
#   account_id = "sa-gke-gar"
# }

# resource "google_project_iam_member" "gke_gar_sa_role_binding" {
#   project = var.gke_configs.clusters.gke_iowa.project_id
#   role    = "roles/artifactregistry.reader"
#   member  = "serviceAccount:${google_service_account.gke_gar_sa.email}"
# }
# /* Bind Workload Identity User to the GAR service account */
# resource "google_service_account_iam_member" "gke_gar_sa_wif_binding" {
#   service_account_id = google_service_account.gke_gar_sa.name
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "serviceAccount:${var.gke_configs.clusters.gke_iowa.project_id}.svc.id.goog[config-management-system/root-reconciler]"
#   depends_on         = [module.gke_iowa]
# }

# /*
#   --- CLUSTER CREATION ---
#   Create the GKE cluster "gke_iowa" with specified configurations.
# */
# module "gke_iowa" {
#   source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
#   version                    = "30.1.0"
#   project_id                 = var.gke_configs.clusters.gke_iowa.project_id
#   name                       = var.gke_configs.clusters.gke_iowa.name
#   region                     = var.gke_configs.clusters.gke_iowa.region
#   kubernetes_version         = var.gke_configs.clusters.gke_iowa.kubernetes_version
#   create_service_account     = var.gke_configs.clusters.gke_iowa.create_service_account
#   service_account_name       = var.gke_configs.clusters.gke_iowa.service_account_name
#   release_channel            = var.gke_configs.clusters.gke_iowa.release_channel
#   zones                      = var.gke_configs.clusters.gke_iowa.zones
#   network                    = var.gke_configs.clusters.gke_iowa.network
#   subnetwork                 = var.gke_configs.clusters.gke_iowa.subnetwork
#   network_project_id         = var.gke_configs.clusters.gke_iowa.network_project_id
#   ip_range_pods              = var.gke_configs.clusters.gke_iowa.ip_range_pods
#   ip_range_services          = var.gke_configs.clusters.gke_iowa.ip_range_services
#   http_load_balancing        = var.gke_configs.clusters.gke_iowa.http_load_balancing
#   network_policy             = var.gke_configs.clusters.gke_iowa.network_policy
#   horizontal_pod_autoscaling = var.gke_configs.clusters.gke_iowa.horizontal_pod_autoscaling
#   filestore_csi_driver       = var.gke_configs.clusters.gke_iowa.filestore_csi_driver
#   enable_private_endpoint    = var.gke_configs.clusters.gke_iowa.enable_private_endpoint
#   enable_private_nodes       = var.gke_configs.clusters.gke_iowa.enable_private_nodes
#   deletion_protection        = var.gke_configs.clusters.gke_iowa.deletion_protection
#   master_ipv4_cidr_block     = var.gke_configs.clusters.gke_iowa.master_ipv4_cidr_block
#   master_authorized_networks = var.gke_configs.clusters.gke_iowa.master_authorized_networks
#   node_pools                 = var.gke_configs.clusters.gke_iowa.node_pools
#   node_pools_oauth_scopes    = var.gke_configs.clusters.gke_iowa.node_pools_oauth_scopes
#   node_pools_labels          = var.gke_configs.clusters.gke_iowa.node_pools_labels
#   node_pools_metadata        = var.gke_configs.clusters.gke_iowa.node_pools_metadata
#   node_pools_taints          = var.gke_configs.clusters.gke_iowa.node_pools_taints
#   node_pools_tags            = var.gke_configs.clusters.gke_iowa.node_pools_tags
#   depends_on                 = [google_project_iam_member.sa_role_binding]
# }

# /*
#  --- FLEET REGISTRATION ---
#  Register the GKE cluster with Google Cloud Fleet for centralized management.
# */
# module "fleet_gke_iowa" {
#   source                    = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
#   version                   = "30.1.0"
#   project_id                = var.gke_configs.clusters.gke_iowa.project_id
#   cluster_name              = module.gke_iowa.name
#   location                  = var.gke_configs.clusters.gke_iowa.region
#   membership_name           = var.gke_configs.clusters.gke_iowa.fleet_membership_name
#   enable_fleet_registration = var.gke_configs.clusters.gke_iowa.enable_fleet_registration
#   depends_on                = [module.gke_iowa]
# }

# /*
#   --- CONFIG MANAGEMENT ---
#   Enable configuration management features (Config Sync, Policy Controller) for the cluster.
# */
# resource "google_gke_hub_feature_membership" "gke_iowa_hub_feature_membership" {
#   provider   = google-beta
#   project    = var.gke_configs.clusters.gke_iowa.project_id
#   depends_on = [google_gke_hub_feature.gke_iowa_fleet_acm, google_service_account_iam_member.gke_gar_sa_wif_binding]
#   location   = "global"
#   feature    = "configmanagement"
#   membership = module.fleet_gke_iowa.cluster_membership_id
#   configmanagement {
#     version = var.gke_configs.clusters.gke_iowa.config_mgmt_version

#     dynamic "config_sync" {
#       for_each = var.gke_configs.clusters.gke_iowa.enable_config_sync ? [{ enabled = true }] : []
#       content {
#         source_format = "unstructured"
#         oci {
#           sync_repo                 = var.gke_configs.clusters.gke_iowa.config_sync_install_repo
#           secret_type               = "gcpserviceaccount"
#           gcp_service_account_email = google_service_account.gke_gar_sa.email
#         }
#       }
#     }

#     dynamic "policy_controller" {
#       for_each = var.gke_configs.clusters.gke_iowa.enable_policy_controller ? [{ enabled = true }] : []
#       content {
#         enabled                    = true
#         template_library_installed = true
#         referential_rules_enabled  = true
#       }
#     }
#   }
# }

/*
  --- PAUSE FOR CONFIG SYNC ---
  Wait for 5 minutes (300 seconds) to allow Config Sync to install and initialize.
*/
# resource "time_sleep" "gke_iowa_wait_config_sync_install" {
#   count           = var.gke_configs.clusters.gke_iowa.enable_config_sync == true ? 1 : 0
#   create_duration = "300s"
#   depends_on      = [google_gke_hub_feature_membership.gke_iowa_hub_feature_membership]
# }

/* GAR Reader for GKE Node SA. */
# resource "google_project_iam_member" "gke_iowa_artifactregistry_reader" {
#   project = var.gke_configs.clusters.gke_iowa.project_id
#   role    = "roles/artifactregistry.reader"
#   member  = "serviceAccount:${module.gke_iowa.service_account}"
# }

# /* Bind Workload Identity Federation for specific manifests (RootSync) to enable secure communication. */
# resource "google_service_account_iam_member" "gke_iowa_wif_binding" {
#   for_each           = { for k, v in var.gke_resources.clusters.gke_iowa.manifests : k => v if v.manifest.kind == "RootSync" }
#   service_account_id = google_service_account.gke_gar_sa.name
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "serviceAccount:${var.gke_configs.clusters.gke_iowa.project_id}.svc.id.goog[${each.value.manifest.metadata.namespace}/root-reconciler-${each.value.manifest.metadata.name}]"
#   depends_on         = [module.gke_iowa]
# }

# data "google_project" "gke_iowa_project" {
#   project_id = var.gke_configs.clusters.gke_iowa.project_id
# }

/*
  --- KUBERNETES PROVIDER SETUP ---
  Configure the Kubernetes provider to interact with the GKE cluster.
*/
# provider "kubernetes" {
#   host  = "https://connectgateway.googleapis.com/v1/projects/${data.google_project.gke_iowa_project.number}/locations/${module.fleet_gke_iowa.location}/gkeMemberships/${var.gke_configs.clusters.gke_iowa.fleet_membership_name}"
#   token = data.google_client_config.provider.access_token
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "/usr/bin/gke-gcloud-auth-plugin"
#   }
#   alias = "gke_iowa_provider"
# }

/*
  --- NAMESPACE CREATION ---
  After cluster creation, Create all the required namespaces within the GKE cluster
*/
# resource "kubernetes_namespace" "gke_iowa_k8s_namespace" {
#   provider = kubernetes.gke_iowa_provider
#   for_each = var.gke_resources.clusters.gke_iowa.namespaces
#   metadata {
#     annotations = each.value.annotations
#     labels      = each.value.labels
#     name        = each.value.name
#   }
#   depends_on = [module.gke_iowa]
# }

/*
  --- CONTROLLER DEPLOYMENT ---
  Deploy the Kubernetes manifests for the controllers first. Once the controller is deployed - Create the secrets.
*/

# resource "kubernetes_manifest" "gke_iowa_k8s_controller_manifests" {
#   provider = kubernetes.gke_iowa_provider
#   for_each = local.gke_iowa_controller_manifests
#   manifest = each.value.manifest
#   depends_on = [kubernetes_namespace.gke_iowa_k8s_namespace,
#     google_gke_hub_feature_membership.gke_iowa_hub_feature_membership,
#     google_service_account_iam_member.gke_iowa_wif_binding,
#     time_sleep.gke_iowa_wait_config_sync_install,
#     google_project_iam_member.gke_iowa_artifactregistry_reader
#   ]
# }

/*
  --- PAUSE FOR CONTROLLER INSTALLATION ---
  Wait for 5 minutes (300 seconds) to allow the controllers to fully install and initialize.
*/

# resource "time_sleep" "gke_iowa_wait_controller_install" {
#   count           = length(local.gke_iowa_controller_manifests) > 0 ? 1 : 0
#   create_duration = "300s"
#   depends_on      = [kubernetes_manifest.gke_iowa_k8s_controller_manifests]
# }

/*
  --- RESOURCE DEPLOYMENT ---
  After controllers and secrets are ready, deploy the remaining Kubernetes manifests (non-controllers).
*/
# resource "kubernetes_manifest" "gke_iowa_k8s_manifests" {
#   provider = kubernetes.gke_iowa_provider
#   for_each = local.gke_iowa_non_controller_manifests
#   manifest = each.value.manifest
#   depends_on = [
#     kubernetes_namespace.gke_iowa_k8s_namespace,
#     kubernetes_manifest.gke_iowa_k8s_controller_manifests,
#     google_gke_hub_feature_membership.gke_iowa_hub_feature_membership,
#     google_service_account_iam_member.gke_iowa_wif_binding,
#     time_sleep.gke_iowa_wait_config_sync_install,
#     time_sleep.gke_iowa_wait_controller_install,
#     google_project_iam_member.gke_iowa_artifactregistry_reader
#   ]
# }
