variable "env" {
  description = "Environment"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "afadpf"
}

variable "factory_project_id" {
  description = "Factory project id"
  type        = string
  default     = "afa-dataplatform-factory"
}

variable "application_project_id" {
  description = "Application project id"
  type        = string
}

variable "enable_service_apis" {
  description = "List of service APIs to enable."
  type        = list(string)
  default = [
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "dataform.googleapis.com",
    "dataplex.googleapis.com",
    "eventarc.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "ml.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "workflowexecutions.googleapis.com",
    "workflows.googleapis.com",
  ]
}

variable "tf_sac_iam_roles" {
  description = "List of roles for the terraform service account"
  type        = list(string)
  default = [
    "roles/editor",
    # security
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/secretmanager.admin",
    # tools
    "roles/artifactregistry.admin",
    "roles/bigquery.admin",
    "roles/cloudbuild.builds.approver",
    "roles/cloudbuild.builds.editor",
    "roles/cloudfunctions.admin",
    "roles/compute.instanceAdmin.v1",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/dataform.admin",
    "roles/dataplex.admin",
    "roles/iam.roleAdmin",
    "roles/iam.serviceAccountUser",
    "roles/logging.admin",
    "roles/logging.configWriter",
    "roles/pubsub.admin",
    "roles/run.admin",
    "roles/storage.admin",
    "roles/workflows.admin",
    "roles/iam.workloadIdentityPoolAdmin"
  ]
}

variable "tf_sac_impersonation_members" {
  description = "List of members that can impersonate terraform service account"
  type        = list(string)
  default     = []
}

variable "location" {
  description = "Resources GCP location"
  type        = string
  default     = "EU"
}
