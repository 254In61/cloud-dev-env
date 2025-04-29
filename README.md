# overview
Ensuring I don't have to be installing Terraform & Terragrunt environments all the time.

I decided to build a container, based on Ubuntu that I will always use for my labs and future builds!

# About container image
Uses ubuntu:latest as the base image.
curl, unzip, gnupg, and other essential dependencies.
Terraform.
Terragrunt.
tf-switcher (TFSwitch).
TFlint.
checkov.
AWS CLI.
Azure CLI.
Python and boto3.
Sets /workspace as the working directory.
Sets the default command to /bin/bash.

# docker image build & run container
 
 build image from Dockerfile
 $ podman build -t cloud-infra-dev-env .

# run container from the image stored in localhost
 $ ~/developer/tools/container-start.sh localhost/cloud-infra-dev-env black-panther

# push to docker.io
 $ ./docker-io-push.sh cloud-infra-dev-env
