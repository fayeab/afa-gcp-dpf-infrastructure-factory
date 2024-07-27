# Setup of Factory project

The resources of the Factory project is manually deployed with terraform (`afa-fac-gcs-common-tf-state`).

```sh
gsutil mb -b on -c standard -l EU -p afa-dataplatform-factory  gs://afa-fac-gcs-common-tf-state
```

### Authentication

Authenticate to gcloud with your principal.

```sh
gcloud auth login
```

### Deployment

Then, you can deploy with the following command:

```
terraform init -backend-config="backend.backend"

terraform plan 

terraform apply
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

No Modules

## Resources

| Name | Type |
|------|------|
| google_artifact_registry_repository.image_docker | resource 
| google_artifact_registry_repository.py_packages | resource 
| google_project_service.project_services | resource
| google_service_account.sac | resource 
| google_project_iam_member.dpf_sac_iam | resource 
| google_project_iam_member.factory_sa_iam | resource
| google_project_iam_member.sac_log_writer | resource 
| google_storage_bucket.bucket_zip_code | resource 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | Factory project id | `string` | `afa-dataplatform-factory` | no |
| enable_service_apis | List of service APIs to enable | `list(string)` |  | no |
| factory_sac_iam_roles | List of roles for the factory service account in the factory project | `list(string)` |  | no |
| dfp_sac_iam_roles | List of roles for the factory service account in the dataplatform project | `list(string)` |  | no |
| list_project_id | List of project id dev/uat/prd | `list(string)` | | yes |
| location | The location for GCP resources | `string` | `EU` | no |
| region | The region for GCP resources | `string` |`europe-west3` | no |


## Outputs

| Name | Description |
|------|-------------|
| <a name="terraform_sac"></a> [factory_service_account](#output\_factory_service_account) | Service Account for the prject factory |
<!-- END_TF_DOCS -->