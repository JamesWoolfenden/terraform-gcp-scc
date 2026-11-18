# holden:ignore:HLD_TF_004
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.31.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "7.31.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
  required_version = ">= 1.5.0"
}
