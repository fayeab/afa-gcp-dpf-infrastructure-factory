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

variable "issuer_uri" {
  description = "The OIDC issuer URL"
  type        = string
}

variable "repository_name" {
  description = "The repository name"
  type        = string
}

variable "user_login" {
  description = "The user login"
  type        = string
}

variable "sac_workload_identity" {
  description = "The service account to use by Workfload Identity"
  type        = string
}