# CIS Bundle and Custom Policies

PAC for this workflow governs the repositories available to the bootstrap cluster for TFC/GHE runner deployments, and is
in Constraint Framework via [Policy
Controller](https://cloud.google.com/kubernetes-engine/enterprise/policy-controller/docs/overview). Policy controller is
enabled on all GKE clusters, and the [default template
library](https://cloud.google.com/kubernetes-engine/enterprise/policy-controller/docs/latest/reference/constraint-template-library#available_constraint_templates)
is also installed. This allows us to use a wide range of available constraint templates.

[OCI](https://opencontainers.org/) packaging is used in tandem with [Config
Sync](https://cloud.google.com/kubernetes-engine/enterprise/config-sync/docs/overview) to manage IAM with Github Actions
Runners, rather than traditional GitOps, which provides ease of management and enhanced security by nature of not
requiring a token from GitHub. With OCI and Config Sync, we are also able to consistently integrate policies across
various namespaces and clusters from a single source of truth via Policy Controller constraints. OCI images will be
pushed to Artifact Registry, and will include Policy Controller constraints that govern GKE clusters in the bootstrap workflow.

These policies will align to CIS-1.5.1 benchmarks for Kubernetes. One decision that is yet to be made is whether GKE
CIS benchmarks are also used to validate the security and compliance of the clusters that run workloads. Please visit
[oci/cis-k8s-bundle](https://github.com/cgsyam-ghe-org/tf-appcode-gke-iac/tree/main/oci/cis-k8s-bundle) to view these
policies.

Custom policies in this directory can be found in `custom/` and for now include a policy to restrict the container image
sources that may be used for deployments.
