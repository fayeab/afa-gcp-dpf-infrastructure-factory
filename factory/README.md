# Setup of Factory project

The resources of the Factory project is manually deployed with terraform (`afa-dpf-gcs-common-tf-state`).

```sh
./setup.sh -p afa-dataplatform-factory
```

## Seeds deployment

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