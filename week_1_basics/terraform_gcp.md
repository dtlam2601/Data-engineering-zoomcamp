Next: [Setting up the Environment on Google Cloud](env_setup.md)

## Local setup
#### Installation:
1. Terraform client installation: https://www.terraform.io/downloads
2. Cloud Provider account: https://console.cloud.google.com/

## Terraform
### Introduction


# GCP
### Setup GCP
1. Create account
2. Create project: dtc-de
3. Setup
   * Service Accounts:
   * https://console.cloud.google.com/iam-admin/iam?project=dtc-de-396509
     * Select IAM & Admin (Add permission) > Service Accounts >
     * Create Service Accounts:
       1. Service account details: dtc-de-user (name and id)
       2. Grant this service account access to project: Viewer.
       3. Grant users access to this service account: (Optional).
   * Authentication: Create keys (.json)
     * After create service account: choose ... (vertical) Actions > Manage keys > Add key (private) .json
     * Note: "D:/DataEngineer/zoomcamp/1_basics/terraform_gcp/gcp_keys" /or "C:/Users/DTLam/.gc"
4. Local setup: download [GCP SDK](https://cloud.google.com/sdk/docs/install-sdk). Follow the instructions to install and connect to your account and project.
   * Follow the instructions to install and connect to your account and project.
   * Note: Single user or All is OK
5. Set Environment for Authentication:
   ```bash
   # Export environment
   set GOOGLE_APPLICATION_CREDENTIALS="<path/to/authkeys>.json"
   # Activated service account credentials for "Local" to Service account GCP, can interactive with terraform
   gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS

   # or by OAuth
   ## Login
   gcloud auth application-default login
   ```

### Project infrastructure modules in GCP
* Google Cloud Storage (GCS): Data Lake
* BigQuery: Data Warehouse

### Setup Access
1. IAM Roles for Service Accounts:
   * Viewer, Storage Admin (for Buckets), Storage Object Admin (for Objects in Bucket), BigQuery Admin
2. Enable these APIs for project:
   * https://console.cloud.google.com/apis/library/iam.googleapis.com
   * https://console.cloud.google.com/marketplace/product/google/iamcredentials.googleapis.com

### Create GCP Infrastructure with Terraform

#### Files
* main.tf
* variables.tf
* Optional: resources.tf, output.tf
* .ttstate

#### Declartions
* terraform
  * backend: state
* provider
  * a set of resource type and/or data sources that Terraform can manage
  * Terraform registry: is the main directory of publicly
* resource
  * blocks to define components of your infrastructure
  * Project modules/resources: google_storage_bucket, google_bigquery_dataset, google_bigquery
* variable & locals

#### Execution Steps
1. Terraform init: Initialize & install
2. Terraform plan: Matches change against to previous state
3. Terraform apply: Apply changes to cloud
4. Terraform destroy: Remove your stack from cloud

#### Setup
* main.tf
  ```terraform
  terraform {
    required_version = ">= 1.0"
    backend "local" {} # Can change from local to "gcs" (google) or "s3" (aws)
    required_providers {
      google = {
          source = "hashicorp/google"
      }
    }
  }
  
  provider "google" {
    project = var.project
    region = var.region
    // credentials = file(var.credentials) # use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
  }
  
  
  # Data Lake Bucket
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
  resource "google_storage_bucket" "data-lake-bucket" {
    name = "${local.data_lake_bucket}_${var.project}"
    location = var.region
  
    # Optional, but recommended settings
    storage_class = var.storage_class
    uniform_bucket_level_access = true
  
    versioning {
      enabled = true
    }
  
    lifecycle_rule {
      action {
        type = "Delete"
      }
      condition {
        age = 30 // days
      }
    }
  
    force_destroy = true
  }
  
  
  # DWH
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
  resource "google_bigquery_dataset" "dataset" {
    dataset_id = var.BQ_dataset
    project = var.project
    location = var.region
  }
  ```

* variables.tf
  ```terraform
    locals {
    data_lake_bucket = "dtc_data_lake"
  }
  
  variable "project" {
    description = ""
  }
  
  variable "region" {
    description = "Region for GCP resources."
    default = "europe-west6"
    type = string
  }
  
  # Not needed for now
  variable "bucket_name" {
    description = "The name of the Google Cloud Storage bucket. Must be globally unique."
    default = ""
  }
  
  variable "storage_class" {
    description = "Storage class type for your bucket. Check official docs for more info."
    default = "STANDARD"
  }
  
  variable "BQ_DATASET" {
    description = "BigQuery Dataset that raw data (from GCS) will be written to"
    type = string
    default = "trips_data_all"
  }
  ```

#### Execution demo
```terraform shell
# Initialize state file (.tfstate)
terraform init

# Check changes to new infra plan
terraform plan -var="project=<your-gcp-project-id>"

# Create new infra
terraform apply -var="project=<your-gcp-project-id>"

# Delete infra after your work, to avoid costs on any running services
terraform destroy
```

### Configuration Terraform and GCP SDK on Windows
#### Instructions
```set CLOUDSDK_PYTHON=~/Anaconda3/python```
>Next: [Setting up the Environment on Google Cloud](env_setup.md)
