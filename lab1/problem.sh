#!/bin/sh

kubectl scale -n voting-app --replicas=10 deployment/voter > /dev/null 2>&1
kubectl scale -n voting-app --replicas=10 deployment/worker > /dev/null 2>&1
