#!/bin/sh
kubectl config delete-context ${cluster}
kubectl config delete-cluster ${cluster}
kubectl config unset users.admin@${cluster}

if [[ $(kubectl config current-context) == "${cluster}" ]]; then
  kubectl config unset current-context
  ctx=$(kubectl config view -o json | jq -r .contexts[0].name)
  if [[ -z "$ctx"  ]]; then
    kubectl config set-cluster local --server=http://localhost:8080
    kubectl config set-context local --cluster=local --namespace=default
    kubectl config use-context local
  else
    kubectl config use-context $ctx
  fi
fi
