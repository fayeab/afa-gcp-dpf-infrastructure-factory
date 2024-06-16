locals {
  github_repos_owner = "fayab"
  github_repos       = ["data-generation-tools"]
  github_issuer_uri  = "https://token.actions.githubusercontent.com"
}

module "workloadidentity_github" {
  source   = "../modules/workloadidentity"
  for_each = toset(local.github_repos)

  project_id                         = var.project_id
  workload_identity_pool_id          = "wip-${each.value}"
  workload_identity_pool_provider_id = "wipp-${each.value}"
  issuer_uri                         = local.github_issuer_uri
  repository_owner                   = local.github_repos_owner
  repository_name                    = each.value
  depends_on                         = [google_project_service.project_services]
}