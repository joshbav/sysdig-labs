#!/bin/sh

kubectl scale -n voting-app --replicas=3 deployment/voter > /dev/null 2>&1
kubectl scale -n voting-app --replicas=1 deployment/worker > /dev/null 2>&1
