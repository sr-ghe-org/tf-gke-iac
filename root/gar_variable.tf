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