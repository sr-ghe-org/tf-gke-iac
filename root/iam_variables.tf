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