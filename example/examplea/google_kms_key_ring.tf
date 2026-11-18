resource "google_kms_key_ring" "scc" {
  name     = "scc-keyring"
  location = "europe-west2"
}
