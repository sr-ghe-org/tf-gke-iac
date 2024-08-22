module "main" {
  source                    = "../../root"
  artifact_registry_configs = var.artifact_registry_configs
  iam_configs               = var.iam_configs
  gke_configs               = var.gke_configs
  gke_resources             = var.gke_resources
}

