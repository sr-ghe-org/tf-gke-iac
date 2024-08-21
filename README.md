# GitOps for GHE and TFC on Google Kubernetes Engine (GKE)

This repository enables a streamlined GitOps approach to managing GitHub Enterprise (GHE) and Terraform Cloud (TFC) deployments on Google Kubernetes Engine (GKE). It leverages Docker containers, Helm charts, and Terraform infrastructure-as-code (IaC) to automate the entire provisioning and deployment process.

### Key Features
- **Automated Pipelines** : GitHub Actions workflows for building and pushing Docker images and Helm charts to Google Artifact Registry.
- **Infrastructure as Code** : Terraform configurations to create artifact registries, GKE clusters, and enable GKE Fleet and Anthos Config Management (ACM).
- **GitOps Principles** : Manage infrastructure and applications declaratively through version-controlled configuration files.
- **Scalability and Reliability** : Leverage GKE's features for high availability and efficient resource management.

## Workflow

1. `Docker Pipeline`: Builds and pushes GHE and TFC Docker images to Artifact Registry.
2. `Helm Pipeline`: Packages and pushes GHE and TFC Helm charts to Artifact Registry.
3. `Terraform Infrastructure`:
    - Creates Artifact Registry to store Docker images and Helm charts.
    - Provisions GKE cluster(s).
    - Enables GKE Fleet and ACM for multi-cluster management.
    - Deploys Helm charts using kubectl manifests.

## Prerequisites

- Google Cloud Project: You need a Google Cloud Project to store artifacts and create resources. 
- Authentication: Authenticate your gcloud CLI with your GCP project: gcloud auth login.
- Terraform: Install Terraform if you haven't already.Terraform Cloud: If using TFC, configure workspaces and variables as needed.
- `kubectl` installed and configured to connect to your Kubernetes cluster.
- `helm` installed.
- Workload Identity Federation: Ensure WIF is configured as a prerequisite(See [Workload Identity](./quickstart-guide/WIF_QUICKSTART.md) quickstart guide)

## Quickstart Guide

Follow these guides to get started quickly:

1. [Workload Identity Setup](./quickstart-guide/WIF_QUICKSTART.md)
2. [GHE ARC & RunnerSet Setup](./quickstart-guide/GHE_QUICKSTART.md)
3. [TFC Operator & Agent Pool Setup](./quickstart-guide/TFC_QUICKSTART.md)

## Deployment & Cleanup Instructions (Important)

NOTE : Creation and Deletion steps should be executed in sequence with a single PR for each step

### Deployment Sequence
To ensure proper setup, follow this **strict deployment sequence**, creating a **separate Pull Request (PR)** for each step:

1. `Cluster Creation`: Establish the GKE cluster infrastructure.
2. `Provider & Namespace`: After cluster creation, set up the provider (e.g., Kubernetes provider) to interact with the clusters.Then, create the necessary namespaces within the clusters.
3. `Controller Deployment`: Deploy the GHE Controller and TFC Operator.
4. `Secrets Creation`: Once the controllers are in place, create and securely store any sensitive configuration data (e.g., GITHUB_PAT, Terraform API Token) as Kubernetes secrets.
5. `Resource Deployment`: Finally, set up the runner set and the agent pool (the worker nodes that actually execute the jobs or tasks).

### Cleanup Sequence 
To safely remove resources, follow this **strict cleanup sequence**, creating a **separate Pull Request(PR)** for each step:

1. Delete Kubernetes Resources: Remove regular Kubernetes resources first.
2. Delete Controller Resources: Remove GHE Controller and TFC Operator resources.
3. Delete Namespace: Delete the created namespace.
4. Delete Cluster: Finally, delete the GKE cluster.




