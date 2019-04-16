# Use Case 2: Monitoring an application deployment

This is a sample microservice application. Is the sock-shop from WeaveWorks.
We receive an update and we deploy the new version, but the application starts
to give us some errors.

Use Sysdig to explore and troubleshoot this error condition.

## How to deploy?

Deploy it using the shell scripts:

* `create.sh` (default target): Deploys in an existing Kubernetes cluster the application
* `update.sh`: Updates the application with the new deployment
* `delete.sh`: Removes deployment
