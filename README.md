# afa-gcp-dpf-infrastructure-factory

# AFA Data Platform

This repository is dedicated to the deployment of the AFA Data Platform.

# Structure  

The `factory` contains the TF code to create the ressources of the factory project. 

The `seeds` contains the TF code to initialize each environment. The resources are manually deployed with terraform. The terraform backend is hosted in the production environnement: 
 * dev: `afa-dpf-gcs-tfstate-dev`
 * uat: `afa-dpf-gcs-tfstate-uat`
 * prd: `afa-dpf-gcs-tfstate-prd`

# Prerequisites

In order to deploy the seed infrastructure for each environment, buckets must be created to store terrraform tfstate.

```sh
bash setup.sh
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