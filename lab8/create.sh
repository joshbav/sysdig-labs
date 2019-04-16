#!/bin/bash

ADD_SECURE=1

cat <<- 'EOF' > "mysql-deployment.yaml"
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: mysql
  labels:
    name: mysql-deployment
    app: demo
spec:
  replicas: 1
  # selector identifies the set of Pods that this
  # replication controller is responsible for managing
  selector:
    matchLabels:
     name: mysql
     role: mysqldb
     app: demo
  template:
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          ports:
            - containerPort: 3306
              name: mysql
          env:
          - name: MYSQL_ROOT_PASSWORD
            value: password
          - name: MYSQL_USER
            value: admin
          - name: MYSQL_PASSWORD
            value: password
          - name: MYSQL_DATABASE
            value: wordpress
          - name: SYSDIG_AGENT_CONF
            value: 'app_checks: [{name: mysql, check_module: mysql, pattern: {comm: mysqld}, conf: { server: 127.0.0.1, user: root, pass: password }}]'
EOF
if [ $ADD_SECURE == 1 ]; then
    cat <<- EOF >> "mysql-deployment.yaml"
        - name: ftest
          image: sysdig/ftest
          command: [ "/usr/local/bin/ftest", "-i", "10800", "-b", "-a", "db_program_spawn_process"]
EOF
fi
cat <<- EOF >> "mysql-deployment.yaml"
    metadata:
      labels:
        # Important: these labels need to match the selector above
        # The api server enforces this constraint.
        name: mysql
        role: mysqldb
        app: demo
EOF

cat <<- 'EOF' > "mysql-service.yaml"
apiVersion: v1
kind: Service
metadata: 
  labels: 
    name: mysql
  name: mysql
spec:
  clusterIP: "None"
  ports:
    - port: 3306
      targetPort: 3306
  selector:
    name: mysql 
    app: demo
    role: mysqldb
EOF


cat <<- EOF > "wordpress-deployment.yaml"
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: woocommerce
  labels:
    name: woocommerce-deployment
    app: demo
spec:
  replicas: 1
  # selector identifies the set of Pods that this
  # replication controller is responsible for managing
  selector:
    matchLabels:
     name: woocommerce
     role: frontend
     app: demo
  template:
    spec:
      containers:
        - name: woocommerce
          image: wordpress
          env:
          - name: WORDPRESS_DB_PASSWORD
            value: password
          - name: WORDPRESS_DB_USER
            value: admin
          - name: WORDPRESS_DB_HOST
            value: mysql.store-frontend.svc.cluster.local:3306
          ports:
          - containerPort: 80
            name: wordpress
    metadata:
      labels:
        # Important: these labels need to match the selector above
        # The api server enforces this constraint.
        name: woocommerce
        role: frontend
        app: demo
EOF

cat <<- EOF > "wordpress-service.yaml"
apiVersion: v1
kind: Service
metadata: 
  labels: 
    name: woocommerce
  name: woocommerce
spec: 
  ports:
    - port: 80
      targetPort: 80
  selector:
    name: woocommerce 
    app: demo
    role: frontend
EOF

cat <<- EOF > "wp-client-deployment.yaml"
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: client
  labels:
    name: client-deployment
    app: demo
spec:
  replicas: 1
  # selector identifies the set of Pods that this
  # replication controller is responsible for managing
  selector:
    matchLabels:
     name: client
     role: clients
     app: demo
  template:
    spec:
      containers:
        - name: client
          image: ltagliamonte/recurling
          env:
          - name: URL
            value: http://woocommerce.store-frontend.svc.cluster.local{/,/readme.html,/wp-login.php,/error1,/error2,/wp-includes/js/utils.js,/wp-content/themes/twentyfifteen/screenshot.png,/wp-content/themes/twentyfifteen/style.css,/wp-content/themes/twentysixteen/js/functions.js,/wp-includes/images/down_arrow.gif,/wp-includes/js/jcrop/Jcrop.gif}
    metadata:
      labels:
        # Important: these labels need to match the selector above
        # The api server enforces this constraint.
        name: client
        role: clients
        app: demo
EOF

kubectl create namespace store-frontend
kubectl create -f mysql-deployment.yaml --namespace=store-frontend
kubectl create -f mysql-service.yaml --namespace=store-frontend
kubectl create -f wordpress-deployment.yaml --namespace=store-frontend
kubectl create -f wordpress-service.yaml --namespace=store-frontend
kubectl create -f wp-client-deployment.yaml --namespace=store-frontend
rm mysql-deployment.yaml mysql-service.yaml wordpress-deployment.yaml wordpress-service.yaml wp-client-deployment.yaml
