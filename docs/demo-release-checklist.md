# Demo release checklist

- [ ] Application tests pass in GitHub Actions.
- [ ] New container image was published to GHCR using a commit-specific tag.
- [ ] The image tag in `charts/demo-app/values.yaml` is updated to the immutable tag.
- [ ] The change was reviewed and merged into the GitOps branch.
- [ ] Argo CD reports the demo app as Synced/Healthy after the rollout settles.
- [ ] Argo Rollouts reports the new revision as Healthy and the AnalysisRun passed.
- [ ] Prometheus is scraping `demo-app` (`up` and `http_requests_total` are present).
- [ ] No critical alerts are firing; Slack notifications are received for a controlled dev test.
- [ ] If a canary abort was tested, stable ReplicaSet recovery and elapsed rollback time were recorded.
