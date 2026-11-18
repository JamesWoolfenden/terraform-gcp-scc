resource "google_scc_notification_config" "main" {
  config_id    = var.config_id
  organization = var.organization_id
  description  = var.description
  pubsub_topic = google_pubsub_topic.findings.id

  streaming_config {
    filter = var.streaming_filter
  }

  depends_on = [google_pubsub_topic_iam_member.scc_publisher]
}
