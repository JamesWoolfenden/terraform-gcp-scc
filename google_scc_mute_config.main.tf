resource "google_scc_mute_config" "main" {
  for_each = var.mute_configs

  mute_config_id = each.key
  parent         = "organizations/${var.organization_id}"
  filter         = each.value.filter
  description    = each.value.description
}
