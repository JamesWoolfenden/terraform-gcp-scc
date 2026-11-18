resource "google_scc_management_organization_security_health_analytics_custom_module" "main" {
  for_each = var.custom_modules

  organization     = var.organization_id
  location         = "global"
  display_name     = each.key
  enablement_state = each.value.enablement_state

  custom_config {
    description    = each.value.description
    recommendation = each.value.recommendation
    severity       = each.value.severity

    predicate {
      expression = each.value.predicate
    }

    resource_selector {
      resource_types = each.value.resource_types
    }
  }
}
