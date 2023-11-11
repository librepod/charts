#  vim: set sw=4

@create-cluster:
  mkdir -p $(pwd)/.data
  k3d cluster create --config k3d-config.yaml
  helm install homepage ./charts/homepage
  until [ -n "$(kubectl wait deployment -n kube-system traefik --for condition=Available=True)" ]; do sleep 5; done
  kubectl create -f ./charts/traefik/traefik-dashboard.yaml
  echo "🎉 k3d cluster is ready to use!"

@delete-cluster:
  k3d cluster delete librepod
  echo "🗑️ k3d cluster deleted!"

update-chart-deps chart:
  helm dependencies update ./charts/{{chart}}

install-to-k3d chart: (update-chart-deps chart)
  helm install {{chart}} ./charts/{{chart}} \
    --set hostIP=127.0.0.1 \
    --set persistence.config.storageClass=local-path \
    --set persistence.uploads.storageClass=local-path \
    --set postgres.config.persistence.storageClass=local-path

install-to-k3d-dry-run chart: (update-chart-deps chart)
  helm install {{chart}} ./charts/{{chart}} \
    --set hostIP=$(kubectl get node -o=jsonpath='{.items[0].status.addresses[0].address}') \
    --set persistence.config.storageClass=local-path \
    --set persistence.uploads.storageClass=local-path \
    --set postgres.persistence.config.storageClass=local-path \
    --debug \
    --dry-run

install chart: (update-chart-deps chart)
  helm install {{chart}} ./charts/{{chart}} \
    --set hostIP=$(kubectl get node -o=jsonpath='{.items[0].status.addresses[0].address}') \

install-dry-run chart: (update-chart-deps chart)
  helm install {{chart}} ./charts/{{chart}} \
    --set hostIP=$(kubectl get node -o=jsonpath='{.items[0].status.addresses[0].address}') \
    --debug \
    --dry-run

upgrade chart:
  helm upgrade -f ./charts/{{chart}}/values.yaml {{chart}} ./charts/{{chart}} \
    --set hostIP=$(kubectl get node -o=jsonpath='{.items[0].status.addresses[0].address}') \

uninstall chart:
  helm uninstall {{chart}}
