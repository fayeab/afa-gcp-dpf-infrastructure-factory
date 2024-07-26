locals {
  github_repos_owner = "fayeab"
  github_repos       = {
    "data-generation-tools" = ["iam.serviceAccountUser", "artifactregistry.admin"]
  }
  github_issuer_uri  = "https://token.actions.githubusercontent.com"
  #sac_roles = { for repo, roles in local.github_repos: 
  #       { for role in roles:
  #          "${repo}_${role}" => {repo = repo, role = repo } } 
  #        } 

}

# Create a Service Account for the Workload identity
resource "google_service_account" "sac_workload_identity" {
  for_each = local.github_repos
  account_id  = substr("wip-sac-${replace(each.value, "/[\\s_\\- \\.]+/", "-")}", 0, 28)
  description = "SAC Workload for ${each.value}"
  project     = var.project_id
}

# Add the Service Account IAM roles
resource "google_project_iam_member" "sac_workload_identity_iam_roles" {
  for_each = toset(local.github_repos)
  project  = var.project_id
  role     = "roles/${each.value.role}"
  member   = "serviceAccount:${google_service_account.sac_workload_identity[each.value.repo].email}"
}

module "workloadidentity_github" {
  source   = "../modules/workloadidentity"
  for_each = local.github_repos

  project_id                         = var.project_id
  workload_identity_pool_id          = "wip-${each.key}"
  workload_identity_pool_provider_id = "wipp-${each.key}"
  issuer_uri                         = local.github_issuer_uri
  repository_owner                   = local.github_repos_owner
  repository_name                    = each.key
  sac_workload_identity              = google_service_account.sac_workload_identity.id
  depends_on                         = [google_project_service.project_services]
}