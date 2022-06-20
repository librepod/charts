VERSION 0.6

testChart:
  FROM earthly/dind:alpine

  RUN apk add --no-cache curl bash git

  # Install k3d tool
  RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.4.1 bash

  WORKDIR /test

  COPY .git .git
  COPY charts charts
  COPY lintconf.yaml ct.yaml chart_schema.yaml .

  WITH DOCKER \
    --pull quay.io/helmpack/chart-testing:v3.6.0 \
    --pull rancher/k3s:v1.23.6-k3s1

    RUN docker run --network host --workdir=/data --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.6.0 ct lint --config ct.yaml \
        && k3d cluster create librepod --wait --kubeconfig-update-default --kubeconfig-switch-context --image rancher/k3s:v1.23.6-k3s1 \
        && sleep 30 \
        && docker run --network host --workdir=/data --volume ~/.kube/config:/root/.kube/config:ro --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.6.0 ct install --config ct.yaml
  END
