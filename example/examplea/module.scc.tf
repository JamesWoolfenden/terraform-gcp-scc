# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "scc" {
  source          = "../../"
  organization_id = var.organization_id
  kms_key_name    = google_kms_crypto_key.scc.id

  custom_modules = {
    public_bucket_without_pap = {
      predicate      = "resource.iamConfiguration.publicAccessPrevention != \"enforced\""
      resource_types = ["storage.googleapis.com/Bucket"]
      severity       = "HIGH"
      recommendation = "Enforce public access prevention on the bucket"
      description    = "Detects Cloud Storage buckets without public access prevention enforced"
    }
  }

  mute_configs = {
    sandbox-low = {
      filter      = "severity = \"LOW\" AND resource.project_display_name = \"sandbox\""
      description = "Low-severity findings in the throwaway sandbox project are accepted risk"
    }
  }

  labels = {
    team = "security"
  }
}
