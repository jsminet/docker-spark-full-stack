# docker-spark-full-stack

Apache Spark and Kyuubi demo with Hadoop, Zeppelin, Hive on Mysql running on docker Swarm

## Useful command

### Launching with docker compose

``docker compose up --remove-orphans``

### Launching with docker swarm

``docker stack deploy -c <(docker-compose config) stack-name``

This swarm stack is fully compatible with raspberry PI, base images are also built on ARRCH64 architecture.

Here is the visualizer result using 3 raspberry PI cluster

![Final result](images/image01.png)

### Scale spark worker

``docker service scale spark_spark-worker=8``

## Swarm networking

Launching this docker compose file as-is will create a ingress/mesh network, the traefik edge router will redirect http and tcp request on correct container accordingly.

Opened RPC ports

|Port|Service|
|---|---|
|3306|MariaDB|
|10009|Apache Kyuubi|
|8020|Namenode|
|9866|Datanode|

Don't forget, opening 9866 port is critical as we send data from a client to all datanode **in the same time**


## Tests on local cluster

Check the **.env** file and search for these environement variables

- SPARK_MASTER_DNS=sparkmaster
- SPARK_WORKER1_DNS=sparkworker1
- SPARK_WORKER2_DNS=sparkworker2
- SPARK_WORKER3_DNS=sparkworker3
- NODEMANAGER_DNS=nodemanager
- RESOURCEMANAGER_DNS=resourcemanager
- VIZ_DNS=viz
- ZEPPELIN_DNS=zeppelin
- ZEPPELIN_SPARKUI_DNS=zeppelin_ui
- NAMENODE_DNS=namenode
- DATANODE1_DNS=datanode1
- DATANODE2_DNS=datanode2
- DATANODE3_DNS=datanode3

Set the corresponding swarm cluster manager IP in your local hosts file, example for 192.168.1.11:2377 as the advertise address

- 192.168.1.11 sparkmaster
- 192.168.1.11 sparkworker1
- 192.168.1.11 sparkworker2
- 192.168.1.11 sparkworker3
- 192.168.1.11 mysql-hive
- 192.168.1.11 nodemanager
- 192.168.1.11 resourcemanager
- 192.168.1.11 viz
- 192.168.1.11 zookeeper
- 192.168.1.11 zeppelin
- 192.168.1.11 zeppelin_ui
- 192.168.1.11 namenode
- 192.168.1.11 datanode1
- 192.168.1.11 datanode2
- 192.168.1.11 datanode3
- 192.168.1.11 resourcemanager
