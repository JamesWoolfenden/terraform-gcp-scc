locals {
  # Organization-level Security Command Center notification service agent —
  # the identity that publishes findings to the notification topic.
  scc_notification_service_agent = "serviceAccount:service-org-${var.organization_id}@gcp-sa-scc-notification.iam.gserviceaccount.com"
}
