# Module - Workload Identity

This module deploys a workload identity

# Usages  

```terraform
locals {
  github_repos_owner = "fayeab"
  github_repos       = ["data-generation-tools"]
  github_issuer_uri  = "https://token.actions.githubusercontent.com"
}

module "workloadidentity_github" {
  source   = "path to module"
  for_each = toset(local.github_repos)

  project_id                         = var.project_id
  workload_identity_pool_id          = "wip-${each.value}"
  workload_identity_pool_provider_id = "wipp-${each.value}"
  issuer_uri                         = local.github_issuer_uri
  repository_owner                   = local.github_repos_owner
  repository_name                    = each.value
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_workloadidentity"></a> [workloadidentity](#modules\_workloadidentity) | ./modules/workloadidentity | n/a |

## Resources

| Name | Type |
|------|------|
| google_iam_workload_identity_pool_provider.pool_provider | resource 
| google_iam_workload_identity_pool.identity_pool | resource 
| google_service_account.sac_workload_identity | resource 
| google_project_iam_member.sac_workload_identity_iam_roles | resource 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP project id | `string` | n/a | yes |
| workload_identity_pool_id | The id of the pool which is the final component of the resource name | `string` | n/a  | yes |
| workload_identity_pool_provider_id | The ID for the provider, which becomes the final component of the resource name | `string` | n/a  | yes |
| issuer_uri | The OIDC issuer URL | `string` | n/a | yes |
| repository_owner | The repository owner | `string` | n/a | yes |
| repository_name | The repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="wip_resource_name"></a> [workload_identity_pool_resource_name](#outputs\_workload_identity_pool_resource_name) | Workload Identity Pool Resource Name |
| <a name="wip_provider_name"></a> [workload_identity_pool_provider_name](#outputs\_workload_identity_pool_provider_name) | Workload Identity Pool Provider Name  |
<!-- END_TF_DOCS -->