#!/bin/sh

AGENTKEY=$1
TAGS=$2
CLUSTER_NAME=$3

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
	echo "This command requires three parameters: AGENTKEY, TAGS and CLUSTER_NAME"
	echo "Example: ./create.sh XXXXX cluster:training training-cluster"
	exit 1
fi

if kubectl get nodes | grep ^gke > /dev/null
then
  echo "This looks like a GKE cluster, making yourself cluster-admin first."
  kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
fi

kubectl create ns sysdig-agent
kubectl create -f sysdig-account.yaml -n sysdig-agent

cp sysdig-secret.yaml sysdig-secret.yaml.dist
cp dragent.yaml dragent.yaml.dist

H_AGENTKEY=`echo -n "$AGENTKEY" | base64`
H_TAGS=`echo -n "$TAGS" | base64`

sed -i.bak "s/  access-key:/  access-key: \"$H_AGENTKEY\"/" sysdig-secret.yaml
sed -i.bak "s/  tags:/  tags: \"$H_TAGS\"/" sysdig-secret.yaml

sed -i.bak "s/customerid:/customerid: $AGENTKEY/" dragent.yaml
sed -i.bak "s/k8s_cluster_name:/k8s_cluster_name: \"$CLUSTER_NAME\"/" dragent.yaml

rm sysdig-secret.yaml.bak
rm dragent.yaml.bak

kubectl create -f sysdig-secret.yaml -n sysdig-agent
kubectl create configmap sysdig-agent-config --from-file=dragent-yaml=dragent.yaml -n sysdig-agent
kubectl create -f sysdig-daemonset-config.yaml -n sysdig-agent

mv sysdig-secret.yaml.dist sysdig-secret.yaml
mv dragent.yaml.dist dragent.yaml
