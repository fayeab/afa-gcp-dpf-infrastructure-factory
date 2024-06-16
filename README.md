# afa-gcp-dpf-infrastructure-factory

# Data Platform afaproj Scan Infrastructure

This repository is dedicated to the deployment of the Data Platform afaproj Scan infrastructure.

# Structure  

The `factory` contains the TF code to create the ressources of the factory project. 

The `seeds` contains the TF code to initialize each environment. The resources are manually deployed with terraform. The terraform backend is hosted in the production environnement : `afa-dpf-gcs-common-tf-state`.

# Prerequisites

In order to deploy the seed infrastructure for each environment, a bucket must be created to store terrraform tfstate.

Production environment has been chosen to host the bucket `afa-dpf-gcs-common-tf-state`.

```sh
bash setup.sh -p proc-data-28
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->