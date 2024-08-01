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
  attribute_condition                = "assertion.namespace_path.startsWith(\"${var.gitlab_namespace_path}\")"
  attribute_mapping = {
    "google.subject"           = "assertion.sub"
    "attribute.project_path"   = "attribute.project_path"
    "attribute.project_id"     = "attribute.project_id"
    "attribute.namespace_id"   = "attribute.namespace_id"
    "attribute.namespace_path" = "attribute.namespace_path"
  }
  oidc {
    issuer_uri = "${var.gitlab_url}/"
  }

}

# Allow the workload identity provider to impersonate the service account
resource "google_service_account_iam_member" "impersonation" {
  #member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/attribute.project_path/${var.gitlab_project_path}"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/*"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = var.sac_workload_identity
}
