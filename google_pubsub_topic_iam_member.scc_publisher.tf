resource "google_pubsub_topic_iam_member" "scc_publisher" {
  topic  = google_pubsub_topic.findings.id
  role   = "roles/pubsub.publisher"
  member = local.scc_notification_service_agent
}
