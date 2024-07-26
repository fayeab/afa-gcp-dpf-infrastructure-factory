#!/bin/bash

BUCKET_NAME_DEV="gs://afa-dpf-gcs-tfstate-dev"
BUCKET_NAME_UAT="gs://afa-dpf-gcs-tfstate-uat"
BUCKET_NAME_PRD="gs://afa-dpf-gcs-tfstate-prd"

PROJECT_DEV="afa-data-platform-dev"
PROJECT_UAT="afa-data-platform-uat"
PROJECT_PRD="afa-data-platform-prd"

gsutil mb -b on -c standard -l EU -p $PROJECT_DEV $BUCKET_NAME_DEV
gsutil mb -b on -c standard -l EU -p $PROJECT_UAT $BUCKET_NAME_UAT
gsutil mb -b on -c standard -l EU -p $PROJECT_PRD $BUCKET_NAME_PRD
