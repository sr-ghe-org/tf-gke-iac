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
    gke_devops_ss = {
      namespaces = {
        /*
        "ghe_runner_scale_set_controller" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-controller-2"
        },
        "ghe_runner_scale_set" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-2"
        },
        "tfc_operator" = {
          annotations = {}
          labels      = {}
          name        = "tfc-operator-2"
        },
        "tfc_agent_pool" = {
          annotations = {}
          labels      = {}
          name        = "tfc-agent-pool-2"
        }
        */
      }
      manifests = {
        /*
        ghe_runner_scale_set_controller = {
          controller = true
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "ghe-controller-2"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-devops-ss-1@prj-appcode-gke-prod-da16.iam.gserviceaccount.com"
                chart                  = "gha-runner-scale-set-controller"
                includeCRDs            = true
                namespace              = "ghe-runner-scale-set-controller-2"
                releaseName            = "ghe-runner-scale-set-controller-2"
                repo                   = "oci://us-central1-docker.pkg.dev/prj-appcode-gke-prod-da16/artifreg-devops-prod"
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
        */
        /*
        ghe_runner_scale_set = {
          controller = false
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "ghe-runner-set-2"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-devops-ss-1@prj-appcode-gke-prod-da16.iam.gserviceaccount.com"
                chart                  = "gha-runner-scale-set"
                namespace              = "ghe-runner-scale-set-2"
                releaseName            = "ghe-runner-scale-set-2"
                repo                   = "oci://us-central1-docker.pkg.dev/prj-appcode-gke-prod-da16/artifreg-devops-prod"
                values = {
                  updateStrategy     = "immediate"
                  githubConfigUrl    = "https://github.com/cgsyam-ghe-org"
                  githubConfigSecret = "pre-defined-secret"
                  controllerServiceAccount = {
                    namespace = "ghe-runner-scale-set-controller-2"
                    name      = "ghe-runner-scale-set-controller-2-gha-rs-controller"
                  }
                }
                version = "0.8.3"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        },
        */
        /*
        tfc_operator = {
          controller = true
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "tfc-operator-2"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-devops-ss-1@prj-appcode-gke-prod-da16.iam.gserviceaccount.com"
                chart                  = "terraform-cloud-operator"
                includeCRDs            = true
                namespace              = "tfc-operator-2"
                releaseName            = "tfc-operator-2"
                repo                   = "oci://us-central1-docker.pkg.dev/prj-appcode-gke-prod-da16/artifreg-devops-prod"
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
        */
        /*
        tfc_agent_pool = {
          controller = false
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "tfc-agent-pool-2"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-devops-ss-1@prj-appcode-gke-prod-da16.iam.gserviceaccount.com"
                chart                  = "terraform-agent-pool"
                namespace              = "tfc-agent-pool-2"
                releaseName            = "tfc-agent-pool-2"
                repo                   = "oci://us-central1-docker.pkg.dev/prj-appcode-gke-prod-da16/artifreg-devops-prod"
                values = {
                  updateStrategy  = "immediate"
                  organization    = "sweta-test-env"
                  tokenSecretName = "tfc-owner"
                  tokenSecretKey  = "token"
                  agentPoolName   = "tf-agent-pool-2"
                  agentTokens = [
                    {
                      name = "tf-agent-pool-2-token"
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
        */
      }
    }
    gke_devops_sr = {
      namespaces = {
        "ghe_runner_scale_set_controller" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-controller-1"
        },
        "ghe_runner_scale_set" = {
          annotations = {}
          labels      = {}
          name        = "ghe-runner-scale-set-2"
        },
        "tfc_operator" = {
          annotations = {}
          labels      = {}
          name        = "tfc-operator-1"
        },
        "tfc_agent_pool" = {
          annotations = {}
          labels      = {}
          name        = "tfc-agent-pool-1"
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
              name      = "ghe-controller-1"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-devops-sr-1@prj-appcode-gke-prod-da16.iam.gserviceaccount.com"
                chart                  = "gha-runner-scale-set-controller"
                includeCRDs            = true
                namespace              = "ghe-runner-scale-set-controller-1"
                releaseName            = "ghe-runner-scale-set-controller-1"
                repo                   = "oci://us-central1-docker.pkg.dev/prj-appcode-gke-prod-da16/artifreg-devops-prod"
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
        ghe_runner_scale_set = {
          controller = false
          manifest = {
            apiVersion = "configsync.gke.io/v1beta1"
            kind       = "RootSync"
            metadata = {
              annotations = {
                "configsync.gke.io/deletion-propagation-policy" = "Foreground"
              }
              name      = "ghe-runner-scale-set-2"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-devops-sr-1@prj-appcode-gke-prod-da16.iam.gserviceaccount.com"
                chart                  = "gha-runner-scale-set"
                namespace              = "ghe-runner-scale-set-2"
                releaseName            = "ghe-runner-scale-set-2"
                repo                   = "oci://us-central1-docker.pkg.dev/prj-appcode-gke-prod-da16/artifreg-devops-prod"
                values = {
                  updateStrategy     = "immediate"
                  githubConfigUrl    = "https://github.com/cgsyam-ghe-org"
                  githubConfigSecret = "ghe-token"
                  controllerServiceAccount = {
                    namespace = "ghe-runner-scale-set-controller-1"
                    name      = "ghe-runner-scale-set-controller-1-gha-rs-controller"
                  }
                }
                version = "0.9.0"
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
              name      = "tfc-operator-1"
              namespace = "config-management-system"
            }
            spec = {
              helm = {
                auth                   = "gcpserviceaccount"
                gcpServiceAccountEmail = "sa-gke-devops-sr-1@prj-appcode-gke-prod-da16.iam.gserviceaccount.com"
                chart                  = "terraform-cloud-operator"
                includeCRDs            = true
                namespace              = "tfc-operator-1"
                releaseName            = "tfc-operator-1"
                repo                   = "oci://us-central1-docker.pkg.dev/prj-appcode-gke-prod-da16/artifreg-devops-prod"
                values = {
                  updateStrategy = "immediate"
                }
                version = "2.1.0"
              }
              sourceFormat = "unstructured"
              sourceType   = "helm"
            }
          }
        },
        # tfc_agent_pool = {
        #   controller = false
        #   manifest = {
        #     apiVersion = "configsync.gke.io/v1beta1"
        #     kind       = "RootSync"
        #     metadata = {
        #       annotations = {
        #         "configsync.gke.io/deletion-propagation-policy" = "Foreground"
        #       }
        #       name      = "tfc-agent-pool-1"
        #       namespace = "config-management-system"
        #     }
        #     spec = {
        #       helm = {
        #         auth                   = "gcpserviceaccount"
        #         gcpServiceAccountEmail = "sa-gke-devops-sr-1@prj-appcode-gke-prod-da16.iam.gserviceaccount.com"
        #         chart                  = "terraform-agent-pool"
        #         namespace              = "tfc-agent-pool-1"
        #         releaseName            = "tfc-agent-pool-1"
        #         repo                   = "oci://us-central1-docker.pkg.dev/prj-appcode-gke-prod-da16/artifreg-devops-prod"
        #         values = {
        #           updateStrategy  = "immediate"
        #           organization    = "sweta-test-org"
        #           tokenSecretName = "tfc-owner"
        #           tokenSecretKey  = "token"
        #           agentPoolName   = "tf-agent-pool-1"
        #           agentTokens = [
        #             {
        #               name = "tf-agent-pool-1-token"
        #             }
        #           ]
        #         }
        #         version = "0.1.0"
        #       }
        #       sourceFormat = "unstructured"
        #       sourceType   = "helm"
        #     }
        #   }
        # }
      }
    }
    gke_devops = {
      namespaces = {
        "ghe_runner_scale_set_controller" = {
          annotations = {}
          labels      = {}
          name        = "ghe-arc"
        },
        "ghe_runner_scale_set" = {
          annotations = {}
          labels      = {}
          name        = "ghe-rs"
        },
        "tfc_operator" = {
          annotations = {}
          labels      = {}
          name        = "tfc-opt"
        },
        "tfc_agent_pool" = {
          annotations = {}
          labels      = {}
          name        = "tfc-agnt"
        }
      }
      manifests = {}
    }
  }
}