resource "google_pubsub_topic" "findings" {
  name                       = var.topic_name
  kms_key_name               = var.kms_key_name
  message_retention_duration = var.message_retention_duration
  labels                     = var.labels

  message_storage_policy {
    allowed_persistence_regions = var.allowed_persistence_regions
  }

  depends_on = [google_kms_crypto_key_iam_member.pubsub_service_agent]
}
