# Cluster Exercise:

In this exercise you will form a cluster of at least 3 nodes with your peer students.
Every student will be responsible to configure his own node correctly so that when starting them all up they will join 
together and form a single cluster.
After the cluster is formed we will exercise some of the things we've learned in the distributed cluster chapter.


## Cluster Cleanup & Preperations:


1. Clear all data from the elasticsearch server:

   Reminder: Clear data by: curl -XDELETE localhost:9200/_all

2. Stop ES Node


## Node Configuration:


Open elasticsearch.yml (located under {ES_HOME}/config) and set the following parameters:


## General:


1. Set cluster name to have a unique value. For example:
    
    cluster.name: my-app-cluster

    It is important to have a unique value that distinguishes your cluster from other clusters on the same subnet.

2. Set node name to have a unique value within your cluster. For example:

    node.name: node-1


## Network & Discovery:


3. Set network.host parameter with your machine's IP or hostname. For example:

    network.host: 172.24.250.15

4. Set the discovery unicast host list:

    discovery.zen.ping.unicast.hosts: ["172.24.250.15", "172.24.250.16"]

    Note that the discovery group of hosts is a special subset of hosts within your cluster that responsible for discovering cluster members within the cluster.
    Please add at least 2 member addresses in the list.


## Single Node Start:


5. With coordination of your team members, start only one node in the cluster.
   Run Cluster Health on the only node (GET _cluster/health?pretty).
   Cluster should be "green" and status should indicate only one node:

    {
          "cluster_name" : "elasticsearch",
          "status" : "green",
          "number_of_nodes" : 1,
          "number_of_data_nodes" : 1,
          "active_primary_shards" : 0
          . . .
    }


6. Run a Count query towards the node (i.e. GET _count?pretty ).
Make sure you have no documents at the beginning:

{
      "count" : 0,
      "_shards" : {
        "total" : 0,
        "successful" : 0,
        "failed" : 0
      }
}


## Load Data:


7. Load some data into ES (e.g. create a document or upload the bulk presidents index).

8. Run again the Cluster Health Check. Notice that status changed into "yellow".
   Explain why ?
   How many primary shards exist ?
   How many replicas exist ?

   Make sure you understand the numbers.


## Join another Node to the cluster


9. Start another node on another host, make sure:
   1. They define the same cluster name
   2. They both define the same discovery hosts list
   3. They both set the network address to an address that is accessible by the other cluster members.

10. Run Cluster Health Check again. Notice the state changed back to "green". Why ?
   Run the shards _cat command: curl node-ip:9200/_cat/shards?v
   How many shards in each node (primaries ? Replicas ?)

11. By looking at the logs, try to determine who is the master ?
   (master can be also determined by running: curl node1:9200/_cat/master)

## Change Number of Replicas


12. Change the number of replicas of the index (from the default value 1 to 2):
curl -XPUT 'node-ip:9200/us/_settings' -d '
{
    "index" : {
        "number_of_replicas" : 2
    }
}'

Did the cluster state changed ? Why ?

13. Start another node in the cluster and make sure we are back to "green" status.

## Try Failover:


14. Stop the first node.

   Notice that status changed to "yellow".

15. Try to run a query towards the second or third node (e.g. GET node2-ip:9200/att/_search?pretty ).
Make sure you that you can still access all your data even though the first node is down.


## Try the following queries:

GET _cat/shards
GET _cat/nodes?v

