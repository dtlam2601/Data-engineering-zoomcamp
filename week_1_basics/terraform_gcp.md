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
     * Select IAM & Admin (Add permission) > Service Accounts >
     * Create Service Accounts > dtc-de-user > Viewer > Done.
   * Authentication: Create keys (.json)
4. Local setup: download Cloud SDK
   * Single user or All is OK
5. Set Environment:
   ```bash
   # Export environment
   set GOOGLE_APPLICATION_CREDENTIALS=D:\DataEngineer\zoomcamp\1_basics\terraform_gcp\gcp_keys\dtc-de-396509-833cbdf2ad0f.json

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
3. 
