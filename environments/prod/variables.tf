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
