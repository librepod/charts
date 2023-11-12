VERSION 0.7

testChart:
  FROM earthly/dind:alpine

  ENV K3S_VERSION=v1.25.3-k3s1
  ENV CT_VERSION=v3.10.1
  ENV K3D_VERSION=v5.6.0

  RUN apk add --no-cache curl bash git just

  # Install k3d tool
  RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=$K3D_VERSION bash

  # Install kubectl
  RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
      && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  # Install helm
  RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

  WORKDIR /test

  COPY --dir .git charts ./
  COPY Justfile k3d-config.yaml lintconf.yaml ct.yaml chart_schema.yaml .

  WITH DOCKER \
    --pull quay.io/helmpack/chart-testing:$CT_VERSION \
    --pull rancher/k3s:$K3S_VERSION

    RUN docker run \
          --network host \
          --workdir=/data \
          --volume $(pwd):/data quay.io/helmpack/chart-testing:$CT_VERSION ct lint \
          --config ct.yaml \
        && just create-cluster \
        && docker run \
          --network host \
          --workdir=/data \
          --volume ~/.kube/config:/root/.kube/config:ro \
          --volume $(pwd):/data quay.io/helmpack/chart-testing:$CT_VERSION ct install --config ct.yaml
  END
