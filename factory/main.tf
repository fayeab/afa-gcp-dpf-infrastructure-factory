locals {
  bucket_zip_code = "afa-gcs-artificats-zipcode"

  dfp_sac_roles = distinct(flatten([
    for project_id in var.list_project_id : [
      for role in var.dfp_sac_iam_roles : {
        project = project_id
        role    = role
      }
    ]
  ]))

  dbt_sac_iam_roles_factory = [
    "roles/artifactregistry.admin",
    "roles/container.admin"
  ]

  list_dbt_sac = [
    "sac-dpf-data-build-tool@afa-data-platform-dev.iam.gserviceaccount.com",
    #"sac-dpf-data-build-tool@afa-data-platform-uat.iam.gserviceaccount.com",
    #"sac-dpf-data-build-tool@afa-data-platform-prd.iam.gserviceaccount.com"
  ]

  list_dbt_sac_prefix = distinct(flatten([
    for sac in local.list_dbt_sac : [
      "serviceAccount:${sac}"
    ]
  ]))

  list_dbt_sac_roles = distinct(flatten([
    for sac in local.list_dbt_sac : [
      for role in local.dbt_sac_iam_roles_factory : {
        sac  = sac
        role = role
      }
    ]
  ]))

}

resource "google_artifact_registry_repository" "image_docker" {
  project       = var.project_id
  location      = var.region
  repository_id = "docker-images-afa-pltfrm"
  description   = "Docker repository for the Platform"
  format        = "DOCKER"
  depends_on    = [google_project_service.project_services]
}

resource "google_artifact_registry_repository" "py_packages" {
  project       = var.project_id
  location      = var.region
  repository_id = "python-packages-afa-pltfrm"
  description   = "Python packages for the Platform"
  format        = "PYTHON"
  depends_on    = [google_project_service.project_services]
}

# Service APIs activation
resource "google_project_service" "project_services" {
  for_each = toset(var.enable_service_apis)

  project = var.project_id
  service = each.value
}

# Factory Service Account
resource "google_service_account" "sac" {
  account_id  = "factory-project-sac"
  description = "Service Account for Factory project"
  project     = var.project_id
  depends_on  = [google_project_service.project_services]
}

# Factory Service Account roles in the DPF project
resource "google_project_iam_member" "dpf_sac_iam" {
  for_each   = { for entry in local.dfp_sac_roles : "${entry.project}.${entry.role}" => entry }
  member     = "serviceAccount:${google_service_account.sac.email}"
  project    = each.value.project
  role       = each.value.role
  depends_on = [google_project_service.project_services]
}

# Factory Service Account roles in the factory project
resource "google_project_iam_member" "factory_sa_iam" {
  for_each = toset(var.factory_sac_iam_roles)

  member     = "serviceAccount:${google_service_account.sac.email}"
  project    = var.project_id
  role       = each.value
  depends_on = [google_project_service.project_services]
}

# Factory Application Service Account role to write logs
resource "google_project_iam_member" "sac_log_writer" {
  for_each = toset(["roles/iam.serviceAccountUser", "roles/logging.logWriter"])

  project    = var.project_id
  member     = google_service_account.sac.member
  role       = each.value
  depends_on = [google_project_service.project_services]
}

resource "google_storage_bucket" "bucket_zip_code" {
  name          = local.bucket_zip_code
  location      = var.location
  project       = var.project_id
  storage_class = "STANDARD"
  depends_on    = [google_project_service.project_services]

}

resource "google_storage_bucket_iam_binding" "dbt_bucket_zip_code_iam" {
  bucket  = google_storage_bucket.bucket_zip_code.name
  role    = "roles/storage.admin"
  members = local.list_dbt_sac_prefix
}

resource "google_project_iam_member" "dbt_sac_iam_factory" {
  for_each = { for entry in local.list_dbt_sac_roles : "${entry.sac}.${entry.role}" => entry }

  member  = "serviceAccount:${each.value.sac}"
  project = var.project_id
  role    = each.value.role
}