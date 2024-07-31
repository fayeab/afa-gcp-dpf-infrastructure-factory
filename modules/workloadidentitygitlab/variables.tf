variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "workload_identity_pool_id" {
  description = "The id of the pool which is the final component of the resource name"
  type        = string
}

variable "workload_identity_pool_provider_id" {
  description = "The ID for the provider, which becomes the final component of the resource name"
  type        = string
}

variable "gitlab_url" {
  description = "The OIDC issuer URL"
  type        = string
  default     = "https://gitlab.com"
}

variable "gitlab_namespace_path" {
  description = "Namespace path to filter auth requests"
  type        = string
}

variable "gitlab_project_path" {
  description = "GitLab project Path to restrict authentication from"
  type        = string
}

variable "repository_name" {
  description = "The repository name"
  type        = string
}

variable "sac_workload_identity" {
  description = "The service account to use by Workfload Identity"
  type        = string
}