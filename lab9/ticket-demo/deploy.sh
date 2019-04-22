#!/bin/bash

kubectl delete -f ticket-server.yaml

SDC_ACCESS_TOKEN='6053db03-a53a-416d-8aa8-29629f6306a2'
ENDPOINT='api.on-prem.sysdig-demo.zone'
 
#curl -k -v -X POST -s 'https://'"${ENDPOINT}"'/api/events' \
#-H 'Content-Type: application/json; charset=UTF-8' \
#-H 'Accept: application/json, text/javascript, */*; q=0.01' \
#-H 'Authorization: Bearer '"${SDC_ACCESS_TOKEN}"'' \
#--data-binary '{"event":{"name":"Deployment: ticket-backend 0.2","description":"deploy","severity":"6","tags":{"build":"0.2"}}}' --compressed

curl -k -v -X POST -s 'https://'"${ENDPOINT}"'/api/v2/events' \
-H 'Content-Type: application/json; charset=UTF-8' \
-H 'Accept: application/json, text/javascript, */*; q=0.01' \
-H 'Authorization: Bearer '"${SDC_ACCESS_TOKEN}"'' \
-d '{"event":{"name":"Deployment: ticket-backend 0.2","description":"Deployment of ticket-backend 0.2 started","severity":3,"scope":"kubernetes.namespace.name=\"ticket-backend\" and kubernetes.deployment.name=\"ticket-server\"","tags":{"build":"0.2"}}}'

kubectl create -f ticket-server-0.2.yaml
