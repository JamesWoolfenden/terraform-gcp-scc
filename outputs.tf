output "notification_config_id" {
  value       = google_scc_notification_config.main.id
  description = "ID of the SCC notification config"
}

output "topic_id" {
  value       = google_pubsub_topic.findings.id
  description = "ID of the Pub/Sub topic SCC findings are published to; attach subscriptions to this"
}

output "custom_module_ids" {
  value       = { for k, v in google_scc_management_organization_security_health_analytics_custom_module.main : k => v.id }
  description = "Map of Security Health Analytics custom module display name to ID"
}

output "mute_config_ids" {
  value       = { for k, v in google_scc_mute_config.main : k => v.id }
  description = "Map of mute config ID to resource ID"
}
