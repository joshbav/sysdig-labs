#!/bin/bash

pushd sysdig-agent
./delete.sh
popd

kubectl delete namespace example-java-app
