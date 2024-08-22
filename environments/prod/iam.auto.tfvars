iam_configs = {
  iam_role_bindings = {
    ghe_sa_binding = {
      project_id            = "cap-prod-gke-6cc6"
      service_account_email = "cap-wf-prod-prod-sa-gke@cap-prod-gke-6cc6.iam.gserviceaccount.com"
      roles = [
        "roles/artifactregistry.writer"
      ]
    }
  }
}

