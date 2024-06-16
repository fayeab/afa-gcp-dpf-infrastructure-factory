output "workload_identity_pool_resource_name" {
  value = google_iam_workload_identity_pool.identity_pool.name
}

output "workload_identity_pool_provider_name" {
  value = google_iam_workload_identity_pool_provider.pool_provider.name
}