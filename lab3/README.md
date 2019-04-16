# Training Lab 3: Kubernetes platform monitoring

In this scenario we will deploy a Sysdig Agent which is configured to scrape Kubernetes metrics from its internal components: API Server, Kubelet, Etcd and Scheduler.

Later we generate load in order to see how the Kubernetes behaves internally, by example:

* How API Server behaves under load conditions?
* How much time Scheduler spends to schedule a pod in a node?
* How etcd database size grows over time?
* How a kubelet uses Docker under the hood to operate in the node?


## How to deploy and use this?

* `create.sh`: Deploys the agent configured to scrape Kubernetes internal metrics.
* `create-dashboard.sh`: Creates the Dashboards in Sysdig Monitor.
* `loadgen.sh`: Adds more load to the current application scaling the `voter` component.
* `delete.sh`: Deletes de agent and if exists the application used to generate load.

### Environment and configuration

This lab requires the following environment variables to be set:

* SYSDIG_AGENT_ACCESS_KEY: The agent access token. Needed for deploying the agent.
* SYSDIG_API_TOKEN: The API token for Sysdig Monitor. Needed for creating the dashboards.
