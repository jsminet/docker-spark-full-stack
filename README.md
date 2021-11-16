# docker-spark-full-stack

Apache Spark and Kyuubi demo with Hadoop, Zeppelin, Hive on Mysql running on docker Swarm

## Useful command

### Launching with docker compose

``docker compose up --remove-orphans``

### Launching with docker swarm

``docker stack deploy -c <(docker-compose config) stack-name``

This swarm stack is fully compatible with raspberry PI, base images are also built on ARRCH64 architecture.

Here is the visualizer result using 3 raspberry PI cluster

![Final result](images\image01.png)

### Scale spark worker

``docker service scale spark_spark-worker=8``

## Swarm networking

Launching this docker compose file as-is will create a ingress/mesh network, the traefik edge router will redirect http and tcp request on correct container accordingly.

Only port 3306 and 10009 are open for MariaDB and Apache Kyuubi

## Tests on local cluster

Check the **.env** file and search for these environement variables

* SPARK_DNS=spark.rpi
* HADOOP_DNS=hadoop.rpi
* VIZ_DNS=viz.rpi

Set the corresponding swarm cluster manager IP in your local hosts file, example for 192.168.0.7:2377 as the advertise address

* 192.168.0.7 spark.rpi
* 192.168.0.7 hadoop.rpi
* 192.168.0.7 viz.rpi