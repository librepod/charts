VERSION 0.6

testChart:
  FROM earthly/dind:alpine

  RUN apk add --no-cache curl bash git

  # Install k3d tool
  RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.4.6 bash

  # Install kubectl
  RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
      && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  WORKDIR /test

  COPY --dir .git charts ./
  COPY ./charts/traefik/traefik.yaml lintconf.yaml ct.yaml chart_schema.yaml .

  WITH DOCKER \
    --pull quay.io/helmpack/chart-testing:v3.7.1 \
    --pull rancher/k3s:v1.23.10-k3s1

    RUN docker run \
          --network host \
          --workdir=/data \
          --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.7.1 ct lint \
          --config ct.yaml \
        && k3d cluster create librepod \
          --image rancher/k3s:v1.23.6-k3s1 \
          --wait \
          --kubeconfig-update-default \
          --kubeconfig-switch-context \
          --k3s-arg "--disable=traefik@server:*" \
        && kubectl create -f traefik.yaml \
        && until [ -n "$(kubectl wait deployment -n kube-system traefik --for condition=Available=True)" ]; do sleep 5; done \
        && docker run \
          --network host \
          --workdir=/data \
          --volume ~/.kube/config:/root/.kube/config:ro \
          --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.7.1 ct install --config ct.yaml
  END
