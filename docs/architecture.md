# Architecture and operational decisions

## Components

- **Terraform**: reusable network, EKS, and platform modules. Dev and prod use the same code but isolated state keys and variable files.
- **Amazon VPC**: public subnets host NAT gateways; EKS worker nodes run in private subnets. Public and private subnet tags support AWS load-balancer integrations if added later.
- **Amazon EKS**: managed control plane, EKS managed node group, cluster creator access entry, and standard managed add-ons.
- **Argo CD**: polls Git and continuously reconciles cluster resources with the desired state in this repository.
- **Argo Rollouts**: executes the canary stages and queries Prometheus through an `AnalysisTemplate`. Failed analysis aborts the rollout and returns service to the stable ReplicaSet.
- **Prometheus / Grafana / Alertmanager**: scrapes the demo app's `/metrics` endpoint, stores time-series data, provides dashboards, evaluates alert rules, and routes alert notifications to Slack.
- **GHCR / GitHub Actions**: builds an OCI image for changes under `app/`; the chart's image tag is updated in Git as a separate desired-state change.

## Canary model

This sample uses **replica-based canary scaling**; it does not configure ALB or service-mesh traffic splitting. `setWeight` is therefore an approximation based on old/new ReplicaSet sizes, not a strict per-request traffic percentage. Exact traffic weights require a supported traffic router.

The `demo-error-rate` AnalysisTemplate checks the fraction of HTTP 5xx requests for the candidate image version over a two-minute Prometheus window. The rollout passes the immutable image tag into the analysis; the app includes that value as a `version` label on its request counter. The query returns zero when there are no samples, so the dev test should generate requests during the analysis window. The app's `/fail` route provides a controlled way to generate errors during dev testing.

## State and environment isolation

- Terraform backend state key differs for dev and prod.
- The backend is stored in S3, with encryption, versioning, TLS-only bucket policy, and a DynamoDB lock table.
- The state bootstrap resources start with local state because a backend cannot depend on the bucket it creates. Back up or migrate that state once bootstrap is complete.
- Never reuse the same backend key for two environments.

## Failure and recovery path

1. Argo CD notices a change in chart values and syncs it.
2. Argo Rollouts creates a canary ReplicaSet and advances through configured steps.
3. Argo Rollouts starts an AnalysisRun after the canary pause.
4. Prometheus evaluates the 5xx ratio query; a result at or above the threshold causes an analysis failure.
5. Argo Rollouts marks the rollout aborted and restores the stable ReplicaSet as the active version.
6. Prometheus alert rules and Alertmanager notify Slack for critical platform/app alerts.

The exact rollback time is an environment measurement, not a guaranteed property of this repository.
