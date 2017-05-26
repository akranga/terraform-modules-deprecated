#!/bin/sh

kubectl config set-cluster ${cluster} \
  --server=${server} \
  --certificate-authority=${ca_pem}

kubectl config set-credentials admin@${cluster} \
  --certificate-authority=${ca_pem} \
  --client-key=${client_key} \
  --client-certificate=${client_pem}

kubectl config set-context ${cluster}  \
  --cluster=${cluster} \
  --user=admin@${cluster} \
  --namespace=${namespace}

[ "${use_context}" = "true" ] && kubectl config use-context ${cluster}