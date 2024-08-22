# /*
#  IMPORTANT NOTE
#  "google_gke_hub_feature" is a project wide setting not a cluster wide setting.
#  So destroying this resource might affect other clusters in the same project. 
# */

# /* TODO : This is a global resource - change the naming to gke_fleet_acm*/
# resource "google_gke_hub_feature" "gke_iowa_fleet_acm" {
#   count    = var.gke_configs.clusters.gke_iowa.enable_fleet_feature ? 1 : 0
#   provider = google-beta
#   project  = var.gke_configs.clusters.gke_iowa.project_id
#   name     = "configmanagement"
#   location = "global"
# }

# resource "google_project_iam_member" "hub_service_agent_hub" {
#   count   = var.gke_configs.clusters.gke_iowa.enable_fleet_feature ? 1 : 0
#   project = var.gke_configs.clusters.gke_iowa.project_id
#   role    = "roles/gkehub.serviceAgent"
#   member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
# }

# resource "google_project_service_identity" "sa_gkehub" {
#   count    = var.gke_configs.clusters.gke_iowa.enable_fleet_feature ? 1 : 0
#   provider = google-beta
#   project  = var.gke_configs.clusters.gke_iowa.project_id
#   service  = "gkehub.googleapis.com"
# }