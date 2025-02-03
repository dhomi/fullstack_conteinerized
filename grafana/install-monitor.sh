HELM_CHART_VERSION="35.5.1"

helm install kube-prom-stack prometheus-community/kube-prometheus-stack --version "${HELM_CHART_VERSION}" \
  --namespace monitoring \
  --create-namespace \
  -f grafana/grafana-helm.yaml