# Workload Identity Federation Bootstrap for Terraform Cloud and GitHub Enterprise on GKE

This guide streamlines the setup of Workload Identity Federation (WIF) in Google Cloud Platform (GCP), enabling secure integration with Terraform Cloud (TFC) and GitHub Enterprise (GHE) for running agents and runners on Google Kubernetes Engine (GKE).

## Prerequisites

- `Google Cloud Project`: A GCP project with billing enabled.
- `Terraform Cloud Account`: An active TFC account.
- `GitHub Enterprise Account`: An account with the ability to create repositories within the GHE organization.
- `gcloud CLI`: The Google Cloud CLI installed and authenticated (`gcloud auth login`).

## Bootstrap Steps

1. Create WIF Pool & Providers:
    - Clone the repository : [`terraform-org-gcp-wif`](https://github.com/cgsyam-ghe-org/terraform-org-gcp-wif)
    - Use the above module for creating the WIP pool and required providers.
    - Run the following commands :`terraform init`,`terraform plan`,`terraform apply`
    
2. Create Bootstrap Terraform Project and Workspace and a GitHub Repository
    - Clone the repository : [`terraform-org-platform-onboard`](https://github.com/cgsyam-ghe-org/terraform-org-platform-onboard/tree/main)
    - Use the above module for creating the terraform cloud and github resources
    - Run the following commands :`terraform init`,`terraform plan`,`terraform apply`

    This step automatically provisions:
        - Terraform projects and workspaces
        - GitHub repositories
        - Service accounts for GitHub and Terraform
        - Workload Identity bindings for secure access
    
3. Grant the sufficient permissions to the service account 
    - roles/compute.networkAdmin
    - roles/artifactregistry.admin
    - roles/container.admin
    - roles/iam.workloadIdentityPoolAdmin
    - roles/resourcemanager.folderAdmin
    - roles/compute.xpnAdmin
    - roles/compute.networkUser



   
