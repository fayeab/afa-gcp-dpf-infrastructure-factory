#!/bin/bash

# set -xe

SEED_HOST_BUCKET_NAME="gs://afa-dpf-gcs-common-tf-state"

usage="$(basename "$0") [-h] [-p PROJECT]
Description:
Setup the seed for a project. This shall be run before applying the setup if no seed was provided for terraform configuration. 

Options:
    -h  show this help text
    -p  the project in which deploying the seed
"

options=':hp:'
while getopts $options opt;
do
    case "$opt" in
        h) echo "$usage"; exit;;
        p) PROJECT=$OPTARG;;
        :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
    esac
done

# mandatory arguments
if [ ! "$PROJECT" ]; then
  echo "a PROJECT must be provided."
  echo "$usage" >&2; exit 1
fi

gsutil mb -b on -c standard -l EU -p $PROJECT $SEED_HOST_BUCKET_NAME
