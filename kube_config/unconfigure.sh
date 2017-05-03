#!/bin/sh
kubectl config delete-context ${cluster}
kubectl config delete-cluster ${cluster}
kubectl config unset users.admin@${cluster}
[ $(kubectl config current-context) == "${cluster}" ] && kubectl config unset current-context
