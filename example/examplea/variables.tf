variable "organization_id" {
  type        = string
  description = "Numeric ID of the GCP organization Security Command Center is enabled on"

  validation {
    condition     = can(regex("^[0-9]+$", var.organization_id))
    error_message = "var.organization_id must be a numeric organization ID"
  }
}
