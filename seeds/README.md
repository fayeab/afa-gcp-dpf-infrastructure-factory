# Setup of Seeds infrastructure


We initialize each environment :
* APIs service activation
* Terraform deployment service account
* Terraform roles for deployment service account
* Terraform impersonation rights for deployment service account
* Terraform backend bucket
* Logs write rights for deployment service account (cloud build requirement)

> This initialization is what we call the seed infrastructure.

## Seeds deployment

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