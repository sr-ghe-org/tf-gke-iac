/*
Deployment Steps:

1. Cluster Creation: Builds the GKE clusters (infrastructure foundation).
2. Provider & Namespace: Configures the Kubernetes provider and creates namespaces for resource organization.
3. Controller Deployment: Deploys core controllers to manage the system.
4. Secrets Creation: Securely stores sensitive configuration data.
5. Resource Deployment: Deploys the actual application components (runner sets, agent pools, etc.).
*/

gke_resources = {
  clusters = {
    gke_iowa = {
      namespaces = {
        "ghe_runner_scale_set_controller" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-controller"
        },
        "ghe_runner_scale_set" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set"
        },
        "tfc_operator" = {
          annotations = {}
          labels      = {}
          name        = "tfc-operator"
        },
        "tfc_agent_pool" = {
          annotations = {}
          labels      = {}
          name        = "tfc-agent-pool"
        }
      }
      manifests = {
        ghe_runner_scale_set_controller = {
          controller = true
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "ghe-runner-scale-set-controller"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-gar@cap-prod-gke-6cc6.iam.gserviceaccount.com"
                chart                  = "gha-runner-scale-set-controller"
                includeCRDs            = true
                namespace              = "ghe-runner-scale-set-controller"
                releaseName            = "ghe-runner-scale-set-controller"
                repo                   = "oci://us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod"
                values = {
                  updateStrategy = "immediate"
                }
                version = "0.8.3"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        },
        ghe_runner_scale_set = {
          controller = false
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "ghe-runner-scale-set"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-gar@cap-prod-gke-6cc6.iam.gserviceaccount.com"
                chart                  = "gha-runner-scale-set"
                namespace              = "ghe-runner-scale-set"
                releaseName            = "ghe-runner-scale-set"
                repo                   = "oci://us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod"
                values = {
                  updateStrategy     = "immediate"
                  githubConfigUrl    = "https://github.com/cgsyam-ghe-org"
                  githubConfigSecret = "pre-defined-secret"
                  controllerServiceAccount = {
                    namespace = ""
                    name      = ""
                  }
                }
                version = "0.8.3"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        },
        tfc_operator = {
          controller = true
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "tfc-operator"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-gar@cap-prod-gke-6cc6.iam.gserviceaccount.com"
                chart                  = "terraform-cloud-operator"
                includeCRDs            = true
                namespace              = "tfc-operator"
                releaseName            = "tfc-operator"
                repo                   = "oci://us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod"
                values = {
                  updateStrategy = "immediate"
                }
                version = "2.1.0"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        }
        tfc_agent_pool = {
          controller = false
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "tfc-agent-pool"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-gar@cap-prod-gke-6cc6.iam.gserviceaccount.com"
                chart                  = "terraform-agent-pool"
                namespace              = "tfc-agent-pool"
                releaseName            = "tfc-agent-pool"
                repo                   = "oci://us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod"
                values = {
                  updateStrategy  = "immediate"
                  organization    = ""
                  tokenSecretName = "tfc-owner"
                  tokenSecretKey  = "token"
                  agentPoolName   = "tf-agent-pool"
                  agentTokens = [
                    {
                      name = "tf-agent-pool"
                    }
                  ]
                }
                version = "0.1.0"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        }
      }
    }
  }
}
