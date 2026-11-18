variable "organization_id" {
  type        = string
  description = "Numeric ID of the GCP organization Security Command Center is enabled on"

  validation {
    condition     = can(regex("^[0-9]+$", var.organization_id))
    error_message = "var.organization_id must be a numeric organization ID (without the organizations/ prefix)"
  }
}

variable "config_id" {
  type        = string
  description = "ID of the SCC notification config"
  default     = "scc-findings"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,127}$", var.config_id))
    error_message = "var.config_id must start with a lowercase letter and contain only lowercase letters, digits or hyphens (max 128 characters)"
  }
}

variable "description" {
  type        = string
  description = "Description of the SCC notification config"
  default     = "Streams active, unmuted high and critical SCC findings to Pub/Sub"

  validation {
    condition     = length(trimspace(var.description)) > 0 && length(var.description) <= 1024
    error_message = "var.description must be a non-empty string of at most 1024 characters"
  }
}

variable "streaming_filter" {
  type        = string
  description = "SCC findings filter for the streaming notification config"
  default     = "state = \"ACTIVE\" AND mute != \"MUTED\" AND (severity = \"HIGH\" OR severity = \"CRITICAL\")"

  validation {
    condition     = length(trimspace(var.streaming_filter)) > 0
    error_message = "var.streaming_filter must be a non-empty filter; an empty filter streams every finding"
  }
}

variable "topic_name" {
  type        = string
  description = "Name of the Pub/Sub topic SCC findings are published to"
  default     = "scc-findings"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_.~+%]{2,254}$", var.topic_name)) && !startswith(var.topic_name, "goog")
    error_message = "var.topic_name must be 3-255 characters, start with a letter and not start with goog"
  }
}

variable "kms_key_name" {
  type        = string
  description = "Cloud KMS crypto key used to encrypt the findings topic (CMEK)"
  sensitive   = true

  validation {
    condition     = can(regex("^projects/[^/]+/locations/[^/]+/keyRings/[^/]+/cryptoKeys/[^/]+$", var.kms_key_name))
    error_message = "var.kms_key_name must be a crypto key ID of the form projects/P/locations/L/keyRings/R/cryptoKeys/K"
  }
}

variable "message_retention_duration" {
  type        = string
  description = "How long the topic retains published messages, in seconds (e.g. 86400s), so subscribers can replay findings"
  default     = "604800s"

  validation {
    condition     = can(regex("^[0-9]+s$", var.message_retention_duration)) && tonumber(trimsuffix(var.message_retention_duration, "s")) >= 600 && tonumber(trimsuffix(var.message_retention_duration, "s")) <= 2678400
    error_message = "var.message_retention_duration must be between 600s and 2678400s (31 days)"
  }
}

variable "allowed_persistence_regions" {
  type        = list(string)
  description = "Regions where findings messages may be stored at rest (data residency)"
  default     = ["europe-west2"]

  validation {
    condition     = length(var.allowed_persistence_regions) > 0 && alltrue([for r in var.allowed_persistence_regions : length(trimspace(r)) > 0])
    error_message = "var.allowed_persistence_regions must contain at least one non-empty region"
  }
}

variable "custom_modules" {
  type = map(object({
    predicate        = string
    resource_types   = list(string)
    severity         = string
    recommendation   = string
    description      = optional(string)
    enablement_state = optional(string, "ENABLED")
  }))
  description = "Optional Security Health Analytics custom modules keyed by display name: a CEL predicate over the listed resource types, with severity and recommendation"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.custom_modules : can(regex("^[a-z][a-z0-9_]{0,127}$", k))])
    error_message = "var.custom_modules keys (display names) must start with a lowercase letter and contain only lowercase letters, digits or underscores (max 128 characters)"
  }

  validation {
    condition     = alltrue([for k, v in var.custom_modules : contains(["CRITICAL", "HIGH", "MEDIUM", "LOW"], v.severity)])
    error_message = "var.custom_modules severity must be one of CRITICAL, HIGH, MEDIUM or LOW"
  }

  validation {
    condition     = alltrue([for k, v in var.custom_modules : contains(["ENABLED", "DISABLED"], v.enablement_state)])
    error_message = "var.custom_modules enablement_state must be ENABLED or DISABLED"
  }

  validation {
    condition     = alltrue([for k, v in var.custom_modules : length(trimspace(v.predicate)) > 0 && length(trimspace(v.recommendation)) > 0 && length(v.resource_types) > 0])
    error_message = "var.custom_modules entries need a non-empty predicate, recommendation and at least one resource type"
  }
}

variable "mute_configs" {
  type = map(object({
    filter      = string
    description = string
  }))
  description = "Optional organization-level SCC mute configs keyed by mute config ID. Each needs a narrow filter and a description justifying why the findings are muted"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.mute_configs : can(regex("^[a-z][a-z0-9-]{0,62}$", k))])
    error_message = "var.mute_configs keys must start with a lowercase letter and contain only lowercase letters, digits or hyphens (max 63 characters)"
  }

  validation {
    condition     = alltrue([for k, v in var.mute_configs : length(trimspace(v.filter)) > 0 && length(trimspace(v.description)) > 0])
    error_message = "var.mute_configs entries need a non-empty filter and description; an empty filter would mute every finding"
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the findings topic, for cost allocation and ownership tracking"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.labels : can(regex("^[a-z][a-z0-9_-]{0,62}$", k)) && can(regex("^[a-z0-9_-]{0,63}$", v))])
    error_message = "var.labels keys and values must be lowercase alphanumerics, underscores, or hyphens, 1-63 characters, keys starting with a letter (GCP label constraints)"
  }
}
