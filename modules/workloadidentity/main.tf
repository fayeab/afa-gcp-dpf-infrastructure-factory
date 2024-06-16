# Create a Workload Identity Pool
resource "google_iam_workload_identity_pool" "identity_pool" {
  workload_identity_pool_id = var.workload_identity_pool_id
  project                   = var.project_id
}

# Create a Workload Identity Provider in that pool
resource "google_iam_workload_identity_pool_provider" "pool_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_pool_provider_id
  display_name                       = substr("Identity pool provider for ${var.repository_name}", 0, 32)
  attribute_condition                = "assertion.repository_owner == '${var.repository_owner}'"
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  oidc {
    issuer_uri = var.issuer_uri
  }

}

# Create a Service Account for the Workload identity
resource "google_service_account" "sac_workload_identity" {
  account_id  = substr("wip-sac-${replace(var.repository_name, "/[\\s_\\- \\.]+/", "-")}", 0, 28)
  description = "SAC Workload for "
  project     = var.project_id
}

# Add the Service Account IAM roles
resource "google_project_iam_member" "sac_workload_identity_iam_roles" {
  for_each = toset(["roles/iam.serviceAccountUser", "roles/artifactregistry.admin"])
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.sac_workload_identity.email}"
}

# Allow the workload identity provider to impersonate the service account
resource "google_service_account_iam_member" "impersonation" {
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/attribute.repository/${var.repository_owner}/${var.repository_name}"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.sac_workload_identity.id
}
