#!/usr/bin/env bash
set -euo pipefail

: "${GITOPS_REPO_URL:?Export GITOPS_REPO_URL, e.g. https://github.com/owner/gitops-platform-eks.git}"

for command in kubectl helm; do
  command -v "$command" >/dev/null 2>&1 || { echo "Missing required command: $command" >&2; exit 1; }
done

if [[ "$GITOPS_REPO_URL" != https://github.com/* ]]; then
  echo "This bootstrap example expects an HTTPS GitHub repository URL." >&2
  exit 1
fi

echo "Installing Argo CD into namespace argocd..."
helm repo add argo https://argoproj.github.io/argo-helm >/dev/null
helm repo update argo >/dev/null
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd --create-namespace \
  --version 10.11.1 \
  --values gitops/bootstrap/argocd-values.yaml

kubectl wait --for=condition=Established crd/applications.argoproj.io --timeout=180s
kubectl wait --for=condition=Established crd/appprojects.argoproj.io --timeout=180s

echo
echo "Create monitoring credentials. Values are hidden while typing."
read -rsp "Slack incoming webhook URL: " SLACK_WEBHOOK_URL
printf '\n'
read -rsp "Strong Grafana admin password: " GRAFANA_ADMIN_PASSWORD
printf '\n'

if [[ -z "$SLACK_WEBHOOK_URL" || "$SLACK_WEBHOOK_URL" != https://* ]]; then
  echo "A non-empty HTTPS Slack webhook URL is required." >&2
  exit 1
fi
if [[ ${#GRAFANA_ADMIN_PASSWORD} -lt 16 ]]; then
  echo "Use a Grafana password with at least 16 characters." >&2
  exit 1
fi

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f - >/dev/null
kubectl -n monitoring create secret generic alertmanager-slack \
  --from-literal=url="$SLACK_WEBHOOK_URL" \
  --dry-run=client -o yaml | kubectl apply -f - >/dev/null
kubectl -n monitoring create secret generic grafana-admin \
  --from-literal=admin-user=admin \
  --from-literal=admin-password="$GRAFANA_ADMIN_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f - >/dev/null
unset SLACK_WEBHOOK_URL GRAFANA_ADMIN_PASSWORD

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
for manifest in platform-project.yaml root-application.yaml; do
  sed "s|REPLACE_WITH_GITOPS_REPO_URL|${GITOPS_REPO_URL}|g" \
    "gitops/bootstrap/${manifest}" > "${tmpdir}/${manifest}"
done

kubectl apply -f "${tmpdir}/platform-project.yaml"
kubectl apply -f "${tmpdir}/root-application.yaml"

echo
echo "Bootstrap submitted. Watch reconciliation with: kubectl get applications -n argocd"
echo "Argo CD dashboard: kubectl -n argocd port-forward svc/argocd-server 8080:443"
echo "Retrieve initial password (if needed): kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
