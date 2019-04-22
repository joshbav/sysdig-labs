#!/bin/bash

kubectl delete -f ticket-server-0.2.yaml

kubectl create -f ticket-server.yaml
