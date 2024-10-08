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
        "ghe_runner_scale_set_controller_iowa" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-controller-iowa"
        },
        "ghe_runner_scale_set_iowa" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-iowa"
        },
        "tfc_operator_iowa" = {
          annotations = {}
          labels      = {}
          name        = "tfc-operator-iowa"
        },
        "tfc_agent_pool_iowa" = {
          annotations = {}
          labels      = {}
          name        = "tfc-agent-pool-iowa"
        }
      }
      manifests = {
        ghe_runner_scale_set_controller_iowa = {
          controller = true
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "ghe-runner-scale-set-controller-iowa"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-gar@cap-prod-gke-6cc6.iam.gserviceaccount.com"
                chart                  = "gha-runner-scale-set-controller"
                includeCRDs            = true
                namespace              = "ghe-runner-scale-set-controller-iowa"
                releaseName            = "ghe-runner-scale-set-controller-iowa"
                repo                   = "oci://us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod"
                values = {
                  updateStrategy = "immediate"
                }
                version = "0.9.0"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        },
        ghe_runner_scale_set_iowa = {
          controller = false
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "ghe-runner-scale-set-iowa"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-gar@cap-prod-gke-6cc6.iam.gserviceaccount.com"
                chart                  = "gha-runner-scale-set"
                namespace              = "ghe-runner-scale-set-iowa"
                releaseName            = "ghe-runner-scale-set-iowa"
                repo                   = "oci://us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod"
                values = {
                  updateStrategy     = "immediate"
                  githubConfigUrl    = "https://github.com/sr-ghe-org"
                  githubConfigSecret = "pre-defined-secret"
                  controllerServiceAccount = {
                    namespace = "ghe-runner-scale-set-controller-iowa"
                    name      = "ghe-runner-scale-set-controller-iowa-gha-rs-controller"
                  }
                }
                version = "0.9.0"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        },
        tfc_operator_iowa = {
          controller = true
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "tfc-operator-iowa"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-gar@cap-prod-gke-6cc6.iam.gserviceaccount.com"
                chart                  = "terraform-cloud-operator"
                includeCRDs            = true
                namespace              = "tfc-operator-iowa"
                releaseName            = "tfc-operator-iowa"
                repo                   = "oci://us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod"
                values = {
                  updateStrategy = "immediate"
                }
                version = "2.4.0"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        }
        tfc_agent_pool_iowa = {
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
                namespace              = "tfc-agent-pool-iowa"
                releaseName            = "tfc-agent-pool-iowa"
                repo                   = "oci://us-central1-docker.pkg.dev/cap-prod-gke-6cc6/artifreg-devops-prod"
                values = {
                  updateStrategy  = "immediate"
                  organization    = "tfc-test-pool"
                  tokenSecretName = "tfc-owner"
                  tokenSecretKey  = "token"
                  agentPoolName   = "tfc-agent-pool-iowa"
                  agentTokens = [
                    {
                      name = "tfc-agent-pool-iowa"
                    }
                  ]
                }
                version = "0.1.2"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        }
      }
    }
    gke_toronto = {
      namespaces = {
        "ghe_runner_scale_set_controller_toronto" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-controller-toronto"
        },
        "ghe_runner_scale_set_toronto" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-toronto"
        },
        "tfc_operator_toronto" = {
          annotations = {}
          labels      = {}
          name        = "tfc-operator-toronto"
        },
        "tfc_agent_pool_toronto" = {
          annotations = {}
          labels      = {}
          name        = "tfc-agent-pool-toronto"
        }
      }
      manifests = {}
    }
  }
}

