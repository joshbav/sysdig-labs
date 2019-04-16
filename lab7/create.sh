#!/bin/bash

PORT=$((30000 + $RANDOM % 10000))

kubectl create ns jenkins
kubectl apply -f jenkins-pvc.yaml
kubectl apply -f jenkins-svc.yaml
kubectl apply -f jenkins-deploy.yaml

while ! kubectl get pods -n jenkins | grep jenkins | grep Running &> /dev/null; do
    echo Waiting until Jenkins is running...
    sleep 10
done

POD_NAME=`kubectl get pods -n jenkins | grep jenkins | awk '{print $1}'`
echo -e "Pod Name: $POD_NAME\n"

echo -n -e "Admin Token: (loading...)\r"
while ! kubectl exec -n jenkins $POD_NAME cat /var/jenkins_home/secrets/initialAdminPassword &> /dev/null; do
   sleep 5;
done 

ADMIN_PASSWD=`kubectl exec -n jenkins $POD_NAME -- cat /var/jenkins_home/secrets/initialAdminPassword`
echo "Admin Token: $ADMIN_PASSWD"
PORT_FORWARD="kubectl port-forward -n jenkins $POD_NAME $PORT:8080"
cat << EOF

____________________________________________________________________________

Please go to the following url and unlock Jenkins using your Admin Token

    Url:        http://localhost:$PORT/
    Token:      $ADMIN_PASSWD

After unlocking Jenkins, skip the initial configuration completely (top right X symbol), and
when you arrive at the main Jenkins Dashboard, execute the next script: ./populate.sh

Jenkins will be restarted, and will ask you to log in again.
Your User and Password are the following:
    
    User:       admin
    Password:   $ADMIN_PASSWD
____________________________________________________________________________

Warning! Closing this shell will cut the connection with Jenkins.
Close it when you are going to end the lab.
If you want to reenable the connection, execute: 
    
$PORT_FORWARD

EOF

$PORT_FORWARD &> /dev/null
