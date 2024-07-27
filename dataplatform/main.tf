locals {
  bucket_format = "%s-gcs-tfstate-%s"
  sac_format    = "%s-sac-pltfrm-%s"
  tf_sac_id = lower(
    format(
      local.sac_format,
      substr(var.app_name, 0, 16),
      var.env,
    )
  )

  tf_state_name = lower(
    format(
      local.bucket_format,
      var.env,
      substr(var.app_name, 0, 16)
    )
  )
}

# Service APIs activation
resource "google_project_service" "project_services" {
  for_each = toset(var.enable_service_apis)

  project = var.application_project_id
  service = each.value
}

# Terraform Service Account
resource "google_service_account" "tf_sac" {
  account_id  = local.tf_sac_id
  description = "Terraform Service Account for ${var.env} env"
  project     = var.application_project_id
}

# Terraform Service Account roles in their respective application projects
resource "google_project_iam_member" "tf_sa_iam" {
  for_each = toset(var.tf_sac_iam_roles)

  member  = "serviceAccount:${google_service_account.tf_sac.email}"
  project = var.application_project_id
  role    = each.value
}

# Terraform Service Account impersonation members
resource "google_service_account_iam_member" "tf_sac_impersonation" {
  for_each = toset(var.tf_sac_impersonation_members)

  member             = each.value
  role               = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.tf_sac.id
}

# Terraform Application Service Account self impersonation to execute terraform init
resource "google_service_account_iam_member" "tf_sac_self_impersonation" {
  member             = google_service_account.tf_sac.member
  role               = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.tf_sac.id
}


# Terraform Application Service Account role to write logs in the seed project (for cloudbuild run)
resource "google_project_iam_member" "tf_sac_log_writer" {
  for_each = toset(["roles/iam.serviceAccountUser", "roles/logging.logWriter"])

  project = var.factory_project_id
  member  = google_service_account.tf_sac.member
  role    = each.value
}

# Terraform state buckets
resource "google_storage_bucket" "tf_state" {
  name     = local.tf_state_name
  project  = var.application_project_id
  location = var.location

  #uniform_bucket_level_access = true
  force_destroy = false

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 10
    }
  }
}

resource "google_storage_bucket_iam_member" "tf_state_sa_member" {

  bucket = google_storage_bucket.tf_state.id
  member = "serviceAccount:${google_service_account.tf_sac.email}"
  role   = "roles/storage.objectAdmin"
}

data "google_project" "current_application_project" {
  project_id = var.application_project_id
}

# BigQuery project quota override (1To/day) for DEV environment
resource "google_service_usage_consumer_quota_override" "quota_bq_project" {
  count          = var.env == "dev" ? 1 : 0
  provider       = google-beta
  project        = data.google_project.current_application_project.number
  service        = "bigquery.googleapis.com"
  metric         = urlencode("bigquery.googleapis.com/quota/query/usage")
  limit          = urlencode("/d/project")
  dimensions     = {}
  override_value = "1048576"
  force          = true
  timeouts {}
}

# BigQuery user quota override (0,25To/day) for DEV environment
resource "google_service_usage_consumer_quota_override" "quota_bq_user" {
  count          = var.env == "dev" ? 1 : 0
  provider       = google-beta
  project        = data.google_project.current_application_project.number
  service        = "bigquery.googleapis.com"
  metric         = urlencode("bigquery.googleapis.com/quota/query/usage")
  limit          = urlencode("/d/project/user")
  dimensions     = {}
  override_value = "262144"
  force          = true
  timeouts {}
}

locals {
  github_repos_owner = "fayeab"
  github_repos       = "afa-gcp-dpf-infrastructure"
  github_issuer_uri  = "https://token.actions.githubusercontent.com"
}

module "workloadidentity_dpf_gitlab" {
  source                             = "../modules/workloadidentity"
  project_id                         = var.application_project_id
  workload_identity_pool_id          = "wip-${local.github_repos}"
  workload_identity_pool_provider_id = "wipp-${local.github_repos}"
  sac_workload_identity              = google_service_account.tf_sac.id
  issuer_uri                         = local.github_issuer_uri
  repository_owner                   = local.github_repos_owner
  repository_name                    = local.github_repos
}