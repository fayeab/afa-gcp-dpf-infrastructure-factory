# Setup of Data Platform infrastructure


We initialize each environment :
* APIs service activation
* Terraform deployment service account
* Terraform roles for deployment service account
* Terraform impersonation rights for deployment service account
* Terraform backend bucket
* Logs write rights for deployment service account (cloud build requirement)

> This initialization is what we call the seed infrastructure.

## Data Platform deployment

### Authentication

Authenticate to gcloud with your principal.

```sh
gcloud auth login
```

### Deployment

Then, you can deploy with the following command:

```
export ENV=<dev|uat|prd>

TF_DATA_DIR=.terraform-${ENV} terraform init \
-backend-config="envs/${ENV}.backend"

TF_DATA_DIR=.terraform-${ENV} terraform plan \
-var-file="envs/${ENV}.tfvars"

TF_DATA_DIR=.terraform-${ENV} terraform apply \
-var-file="envs/${ENV}.tfvars"
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

No Modules.

## Resources

| Name | Type |
|------|------|
| google_project_service.project_services | resource 
| google_service_account.tf_sac | resource 
| google_project_iam_member.tf_sa_iam | resource 
| google_service_account_iam_member.tf_sac_impersonation | resource 
| google_service_account_iam_member.tf_sac_self_impersonation | resource 
| google_project_iam_member.tf_sac_log_writer | resource 
| google_storage_bucket.tf_state | resource 
| google_storage_bucket_iam_member.tf_state_sa_member | resource 
| google_service_usage_consumer_quota_override.quota_bq_project | resource 
| google_service_usage_consumer_quota_override.quota_bq_user | resource
| google_project.current_application_project | data 


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | The environment dev/uat/prd | `string` | `dev` | no
| app_name | The Application name | `string` | `afadpf` | no 
| factory_project_id | Factory GCP project id | `string` | `afa-dataplatform-factory` | no |
| application_project_id | The Application project id (dev/uat/prd) | `string` | n/a | yes |
| enable_service_apis | List of service APIs to enable | `list(string)` |  | no |
| tf_sac_iam_roles | List of roles for the terraform service account | `list(string)` | | no |
| tf_sac_impersonation_members | List of members that can impersonate terraform service account |`list(string)` | | no |
| location | Resources GCP location | `string` | `EU` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="terraform_sac"></a> [terraform_service_account](#output\_terraform_service_account) | Terraform Service Account |
<!-- END_TF_DOCS -->