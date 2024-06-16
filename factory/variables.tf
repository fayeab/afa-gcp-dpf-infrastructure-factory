variable "project_id" {
  description = "Factory project id"
  type        = string
  default     = "afa-dataplatform-factory"
}

variable "enable_service_apis" {
  description = "List of service APIs to enable."
  type        = list(string)
  default = [
    "artifactregistry.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "pubsub.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

variable "factory_sac_iam_roles" {
  description = "List of roles for the factory service account in the factory project"
  type        = list(string)
  default = [
    "roles/editor",
    # security
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    # tools
    "roles/artifactregistry.admin",
    "roles/cloudfunctions.admin",
    "roles/iam.roleAdmin",
    "roles/iam.serviceAccountUser",
    "roles/logging.admin",
    "roles/logging.configWriter",
    "roles/pubsub.admin",
    "roles/run.admin",
    "roles/storage.admin",
  ]
}

variable "dfp_sac_iam_roles" {
  description = "List of roles for the factory service account in the dataplatform project"
  type        = list(string)
  default = [
    "roles/storage.admin"
  ]
}


variable "list_project_id" {
  description = "List of project id"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "Resources GCP location"
  type        = string
  default     = "europe-west1"
}
