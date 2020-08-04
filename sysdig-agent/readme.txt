Install directions for Sysdig SaaS on K8s, as of 7-20

1. kubectl create ns sysdig-agent

2. kubectl -n sysdig-agent create secret generic sysdig-agent --from-literal=access-key=YOUR-SYSDIG-ACCESS-KEY

3. kubectl apply -n sysdig-agent -f sysdig-agent-clusterrole.yaml
3a. kubectl apply -n sysdig-agent -f https://raw.githubusercontent.com/joshbav/sysdig-labs/master/sysdig-agent/sysdig-agent-clusterrole.yaml

4. kubectl create -n sysdig-agent serviceaccount sysdig-agent

5. kubectl create clusterrolebinding sysdig-agent --clusterrole=sysdig-agent --serviceaccount=sysdig-agent:sysdig-agent

6. kubectl apply -n sysdig-agent -f sysdig-agent-configmap.yaml
6a. kubectl apply -n sysdig-agent -f https://raw.githubusercontent.com/joshbav/sysdig-labs/master/sysdig-agent/sysdig-agent-configmap.yaml,https://raw.githubusercontent.com/joshbav/sysdig-labs/master/sysdig-agent/sysdig-agent-daemonset-v2.yaml,https://raw.githubusercontent.com/joshbav/sysdig-labs/master/sysdig-agent/sysdig-image-analyzer-configmap.yaml,https://raw.githubusercontent.com/joshbav/sysdig-labs/master/sysdig-agent/sysdig-image-analyzer-daemonset.yaml

7. kubectl apply -f sysdig-agent-daemonset-v2.yaml -n sysdig-agent
8. kubectl apply -f sysdig-image-analyzer-configmap.yaml -n sysdig-agent
9. kubectl apply -f sysdig-image-analyzer-daemonset.yaml -n sysdig-agent

UNINSTALL DIRECTIONS
1. kubectl delete ns sysdig-agent
2. kubectl delete clusterrole sysdig-agent
3. kubectl delete clusterrolebinding sysdig-cluster-role-binding
