terraform {
  required_version = "~> 1.8.5"
  backend "gcs" {
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.9.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.9.0"
    }
  }
}
