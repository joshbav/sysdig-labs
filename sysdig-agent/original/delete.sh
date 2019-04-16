#!/bin/sh

kubectl delete clusterrole sysdig-cluster-role
kubectl delete clusterrolebinding sysdig-cluster-role-binding
kubectl delete ns sysdig-agent
