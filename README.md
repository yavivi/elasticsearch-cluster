# Elasticsearch Cluster

## Description
Allows you to standup an Elasticsearch cluster and Kibana on your local machine.

## Prerequisites
The following should be installed on your machine:
1. [VirtualBox](https://www.virtualbox.org)
2. [Vagrant](https://www.vagrantup.com)

## Starting the Cluster
Optionally, set the desired number of nodes in the cluster (default=1 if not set). For example for a cluster of size 3:
```shell
export ES_NUM_NODES=3   (Linux)
set ES_NUM_NODES=3      (Windows)
```
Change directory to the cloned repository:
```shell
cd elasticsearch-cluster
```
Start the cluster:
```shell
vagrant up
```
Kibana Can be reached in the following URL:
http://localhost:5601

## SSH-ing to the machine
Nodes are created with the names node-1, node-2, etc. 
In order to SSH to node-1 type:

```shell
vagrant ssh node-1
```
## Controlling the Elastic Services
Both Elastic and Kibana Services are systemd services and therefore can be controlled with systemctl commands.
For example, restarting the Elasticsearch Service:
```shell
sudo systemctl restart elasticsearch.service
```
Other available actions: start/stop/status etc.

**Note:** Kibana Service is installed only on **node-1**

