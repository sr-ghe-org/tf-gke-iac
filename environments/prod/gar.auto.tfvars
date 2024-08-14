artifact_registry_configs = {
  repositories = {
    artifreg-devops-prod = {
      repository_id = "artifreg-devops-prod"
      mode          = "STANDARD_REPOSITORY"
      project_id    = "cap-prod-gke-6cc6"
      format        = "DOCKER"
      location      = "us-central1"
      description   = "Docker registry - prod"
      labels        = {}
    }
  }
}
