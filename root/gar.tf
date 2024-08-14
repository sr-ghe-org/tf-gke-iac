resource "google_artifact_registry_repository" "repository" {
  for_each      = var.artifact_registry_configs.repositories
  project       = each.value.project_id
  location      = each.value.location
  repository_id = each.value.repository_id
  description   = each.value.description
  format        = each.value.format
  mode          = each.value.mode
  labels        = each.value.labels
}