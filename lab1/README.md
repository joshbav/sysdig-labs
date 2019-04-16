# Training Lab 1: Application performance analysis

In this scenario we will deploy an example microservice voting app in Kubernetes that issues votes for your favourite: dogs or cats. Results are stored in a database and then a report can be generated with the results.

Suddenly there is more people voting using our application and the app becomes slower and slower. In this lab we will find the microservices bottleneck and check how we can scale this application to handle the required load.

## How to deploy and use this?

* `create.sh`: Deploys the application in an existing Kubernetes cluster.
* `stress.sh`: Adds more load to the current application scaling the `voter` component.
* `scale.sh`: Scales the `vote` component increating the number of instances to handle more load.
* `clean.sh`: Removes the application.
