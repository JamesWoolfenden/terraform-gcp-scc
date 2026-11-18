# GCP IAM is eventually consistent: depends_on only orders the apply graph, it
# doesn't wait for a grant to propagate. Creating the CMEK topic straight after
# the KMS grant, or the notification config straight after the publisher
# grant, can fail on the first apply.
resource "time_sleep" "kms_propagation" {
  create_duration = "60s"

  depends_on = [google_kms_crypto_key_iam_member.pubsub_service_agent]
}

resource "time_sleep" "publisher_propagation" {
  create_duration = "60s"

  depends_on = [google_pubsub_topic_iam_member.scc_publisher]
}
