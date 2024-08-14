locals {
  iam_role_bindings = flatten([
    for binding_name, binding_config in var.iam_configs.iam_role_bindings : [
      for role in binding_config.roles : {
        binding_name          = binding_name
        role                  = role
        project_id            = binding_config.project_id
        service_account_email = binding_config.service_account_email
      }
    ]
  ])
}

resource "google_project_iam_member" "sa_role_binding" {
  for_each = {
    for binding in local.iam_role_bindings :
    "${binding.binding_name}-${binding.role}" => binding
  }
  project = each.value.project_id
  role    = each.value.role
  member  = "serviceAccount:${each.value.service_account_email}"
}