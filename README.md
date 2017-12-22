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
## Kibana
Kibana Can be reached in the following URL:

http://localhost:5601

In the main screen you can switch to "Dev Tools" tab and execute an Elasticsearch Query or API.
For example, the following command shall display the nodes status in the cluster:

```http
GET _cat/nodes?v
```

```
ip           heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
192.168.10.3           12          97   0    0.00    0.10     0.07 mdi       -      node-2
192.168.10.4           14          96  38    0.44    0.28     0.12 mdi       -      node-3
192.168.10.2           13          95   1    0.08    0.06     0.07 mdi       *      node-1
```


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

## Locations
**Elasticsearch:**

Installation Dir:   /usr/share/elasticsearch

Configuration Dir: /etc/elasticsearch

Logs Dir:          /var/logs/elasticsearch




