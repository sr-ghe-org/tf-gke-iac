/*
Deployment Steps:
1. Cluster Creation: Builds the GKE clusters (infrastructure foundation).
2. Provider & Namespace: Configures the Kubernetes provider and creates namespaces for resource organization.
3. Controller Deployment: Deploys core controllers to manage the system.
4. Secrets Creation: Securely stores sensitive configuration data.
5. Resource Deployment: Deploys the actual application components (runner sets, agent pools, etc.).
*/

gke_configs = {
  /*
  --- CLUSTER CREATION ---
  Creates the GKE clusters, the first step in the deployment process.
  After cluster creation, proceed with provider setup and namespace creation. 
  */
  clusters = {
    gke_iowa = {
      project_id                 = "cap-prod-gke-6cc6"
      name                       = "gke-iowa-cluster"
      region                     = "us-central1"
      zones                      = ["us-central1-a", "us-central1-b", "us-central1-c"]
      network                    = "vpc-devops-prod"
      subnetwork                 = "subnet-devops-prod-uc1"
      ip_range_pods              = "secrange-devops-prod-pods-uc1"
      ip_range_services          = "secrange-devops-prod-svc-uc1"
      master_ipv4_cidr_block     = "10.0.0.0/28"
      kubernetes_version         = "1.29.6-gke.1254000"
      release_channel            = "STABLE"
      network_project_id         = "cap-prod-network-3a4b"
      config_sync_install_repo   = "us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod/oci/cis-k8s-policy-bundle:1.5.1"
      service_account_name       = "sa-gke-iowa"
      create_service_account     = true
      master_authorized_networks = [{ cidr_block = "10.8.8.0/24", display_name = "everything" }]
      node_pools = [
        {
          name                      = "default-node-pool"
          machine_type              = "e2-medium"
          node_locations            = "us-central1-a,us-central1-b,us-central1-c"
          min_count                 = 1
          max_count                 = 10
          local_ssd_count           = 0
          spot                      = false
          local_ssd_ephemeral_count = 0
          disk_size_gb              = 100
          disk_type                 = "pd-standard"
          image_type                = "COS_CONTAINERD"
          enable_gcfs               = false
          enable_gvnic              = false
          logging_variant           = "DEFAULT"
          auto_repair               = true
          auto_upgrade              = true
          preemptible               = false
          initial_node_count        = 1
        },
      ]
      node_pools_oauth_scopes = {
        all = [
          "https://www.googleapis.com/auth/logging.write",
          "https://www.googleapis.com/auth/monitoring",
          "https://www.googleapis.com/auth/devstorage.read_only"
        ]
      }
      enable_fleet_registration = true
      enable_policy_controller  = true
      enable_fleet_feature      = true
      enable_config_sync        = true
      fleet_membership_name     = "gke-iowa-cluster"
    },
    gke_toronto = {
      project_id                 = "cap-prod-gke-6cc6"
      name                       = "gke-toronto-cluster"
      region                     = "us-central1"
      zones                      = ["us-central1-a", "us-central1-b", "us-central1-c"]
      network                    = "vpc-devops-prod"
      subnetwork                 = "subnet-devops-prod-uc1"
      ip_range_pods              = "secrange-devops-prod-pods-uc1"
      ip_range_services          = "secrange-devops-prod-svc-uc1"
      master_ipv4_cidr_block     = "10.1.1.0/28"
      kubernetes_version         = "1.29.6-gke.1254000"
      release_channel            = "STABLE"
      network_project_id         = "cap-prod-network-3a4b"
      config_sync_install_repo   = "us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod/oci/cis-k8s-policy-bundle:1.5.1"
      service_account_name       = "sa-gke-toronto"
      create_service_account     = true
      master_authorized_networks = [{ cidr_block = "10.8.8.0/24", display_name = "everything" }]
      node_pools = [
        {
          name                      = "default-node-pool"
          machine_type              = "e2-medium"
          node_locations            = "us-central1-a,us-central1-b,us-central1-c"
          min_count                 = 1
          max_count                 = 10
          local_ssd_count           = 0
          spot                      = false
          local_ssd_ephemeral_count = 0
          disk_size_gb              = 100
          disk_type                 = "pd-standard"
          image_type                = "COS_CONTAINERD"
          enable_gcfs               = false
          enable_gvnic              = false
          logging_variant           = "DEFAULT"
          auto_repair               = true
          auto_upgrade              = true
          preemptible               = false
          initial_node_count        = 1
        },
      ]
      node_pools_oauth_scopes = {
        all = [
          "https://www.googleapis.com/auth/logging.write",
          "https://www.googleapis.com/auth/monitoring",
          "https://www.googleapis.com/auth/devstorage.read_only"
        ]
      }
      enable_fleet_registration = true
      enable_policy_controller  = true
      enable_fleet_feature      = true
      enable_config_sync        = true
      fleet_membership_name     = "gke-toronto-cluster"
    }
  }
}
