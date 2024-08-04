
locals {
  app                = "dpf"
  runtime            = "python311"
  topic_name         = "function-generate-data"
  source_object_name = "functionGenerateData.zip"
  func_iam_roles     = ["storage.objectUser", "pubsub.publisher"]
  env_var            = "{\"LIST_BUCKET_NAME\": [\"gcs-afadpf-raw-dev\", \"gcs-afadpf-raw-uat\", \"gcs-afadpf-raw-prd\"], \"TOPIC_NAME\" : \"${local.topic_name}\", \"GOOGLE_CLOUD_PROJECT\" : \"${var.project_id}\"}"
}

resource "google_pubsub_topic" "pubsub_topic" {
  project = var.project_id
  name    = local.topic_name
}

data "archive_file" "python_code" {
  type        = "zip"
  source_dir  = "${path.root}/../src/python/function-generate-data"
  output_path = "${path.root}/${local.source_object_name}"
}

resource "google_storage_bucket_object" "archive_function_code" {
  name   = "${data.archive_file.python_code.output_md5}.zip"
  bucket = google_storage_bucket.bucket_zip_code.name
  source = "${path.root}/${local.source_object_name}"
}

module "function_generate_data" {
  source = "git::https://github.com/fayeab/afa-gcp-dpf-infrastructure-template.git//modules/function?ref=v0.1.0"

  project_id         = var.project_id
  app                = local.app
  source_bucket_name = google_storage_bucket.bucket_zip_code.name
  source_object_name = google_storage_bucket_object.archive_function_code.name
  pubsub_topic_id    = google_pubsub_topic.pubsub_topic.id
  func_iam_roles     = local.func_iam_roles
  entry_point        = "main"
  env_var            = local.env_var
  env                = "gen"
  runtime            = local.runtime
}

resource "google_cloud_scheduler_job" "scheduler_gen_data" {
  for_each = local.schedule_gen_data

  paused    = false
  project   = var.project_id
  region    = var.region
  name      = "dpf-sch-pub-gen-${replace(each.key, "_", "-")}-data"
  schedule  = each.value.schedule
  time_zone = "Europe/Paris"

  pubsub_target {
    topic_name = google_pubsub_topic.pubsub_topic.id
    data       = base64encode("${each.key};${each.value.format}")
  }

  depends_on = [google_project_service.project_services]
}