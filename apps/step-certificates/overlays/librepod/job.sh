#!/bin/bash

# This file is a slightly modified version of the official step bootstrapper
# entrypoint taken from here:
# https://github.com/smallstep/helm-charts/blob/master/docker/step-ca-bootstrap/entrypoint.sh 
# 💣 ATTENTION
# Since we are not going to use Autocert in LibrePod, all Autocert logic had been
# removed from this entrypoint.

echo "Welcome to Step Certificates configuration."

STEPPATH=/home/step

# assert_variable exists if the given variable is not set.
function assert_variable () {
  if [ -z "$1" ];
  then
    echo "Error: variable $1 has not been set."
    exit 1
  fi
}

# check required variables
assert_variable "$NAMESPACE"
assert_variable "$PREFIX"
# assert_variable "$LABELS"
assert_variable "$CA_URL"
assert_variable "$CA_NAME"
assert_variable "$CA_DNS"
assert_variable "$CA_ADDRESS"
assert_variable "$CA_DEFAULT_PROVISIONER"

# generate password if necessary
CA_PASSWORD=${CA_PASSWORD:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')}
CA_PROVISIONER_PASSWORD=${CA_PROVISIONER_PASSWORD:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')}

echo -e "\e[1mChecking cluster permissions...\e[0m"

# Setting this here on purpose, after the above section which explicitly checks
# for and handles exit errors.
set -e

TMP_CA_PASSWORD=$(mktemp /tmp/stepca.XXXXXX)
TMP_CA_PROVISIONER_PASSWORD=$(mktemp /tmp/stepca.XXXXXX)

echo $CA_PASSWORD > $TMP_CA_PASSWORD
echo $CA_PROVISIONER_PASSWORD > $TMP_CA_PROVISIONER_PASSWORD

step ca init \
  --name "$CA_NAME" \
  --dns "$CA_DNS_1" \
  --dns "$CA_DNS_2" \
  --dns "$CA_DNS_3" \
  --dns "$CA_DNS_4" \
  --deployment-type standalone \
  --address "$CA_ADDRESS" \
  --password-file "$TMP_CA_PASSWORD" \
  --provisioner "$CA_DEFAULT_PROVISIONER" \
  --provisioner-password-file "$TMP_CA_PROVISIONER_PASSWORD" \
  --with-ca-url "$CA_URL" \
  --no-db

rm -f $TMP_CA_PASSWORD $TMP_CA_PROVISIONER_PASSWORD

echo
echo -e "\e[1mCreating configmaps and secrets in $NAMESPACE namespace ...\e[0m"

function kbreplace() {
  kubectl $@ -o yaml --dry-run=client | kubectl replace -f -
}

# Replace secrets created on helm install
# It allows to properly remove them on help delete
kbreplace -n $NAMESPACE create configmap $PREFIX-config --from-file $(step path)/config
kbreplace -n $NAMESPACE create configmap $PREFIX-certs --from-file $(step path)/certs
kbreplace -n $NAMESPACE create configmap $PREFIX-secrets --from-file $(step path)/secrets

kbreplace -n $NAMESPACE create secret generic $PREFIX-ca-password --from-literal "password=${CA_PASSWORD}"
kbreplace -n $NAMESPACE create secret generic $PREFIX-provisioner-password --from-literal "password=${CA_PROVISIONER_PASSWORD}"

# # Label all configmaps and secrets
# kubectl -n $NAMESPACE label configmap $PREFIX-config $LABELS
# kubectl -n $NAMESPACE label configmap $PREFIX-certs $LABELS
# kubectl -n $NAMESPACE label configmap $PREFIX-secrets $LABELS
# kubectl -n $NAMESPACE label secret $PREFIX-ca-password $LABELS
# kubectl -n $NAMESPACE label secret $PREFIX-provisioner-password $LABELS

FINGERPRINT=$(step certificate fingerprint $(step path)/certs/root_ca.crt)

echo
echo -e "\e[1mStep Certificates installed!\e[0m"
echo
echo "CA URL: ${CA_URL}"
echo "CA Fingerprint: ${FINGERPRINT}"
echo
