
## <p align="center">POC using Apache Spark / Minio / Apache Kyuubi / Apache Zeppelin / Hive on Postgres / Docker Swarm</p>
  
Apache Spark and Kyuubi demo with Minio S3, Zeppelin notebook, Hive on Postgres running on docker Swarm as orchestrator.
    
## 🧐 Features    
- Using docker compose version 2
- Traefik as an tcp/http edge proxy
- Apache spark in a hybrid standalone/swarm mode
- Apache Kyuubi to have a secure access through JDBC and SQL queries commands
- Get data access with Zeppelin notebooks
- Apache Hive for table storage in parquet format 
        
## 🛠️ Tech Stack
- [Apache Kyuubi](https://kyuubi.apache.org/)
- [Apache Spark](https://spark.apache.org/)
- [Apache Hive](https://hive.apache.org/)
- [Apache Hadoop HDFS](https://hadoop.apache.org/) - DEPRECATED storage, check MinIO
- [MinIO](https://min.io/)
- [Apache Zeppelin](https://zeppelin.apache.org/)
- [Traefik](https://doc.traefik.io/traefik/)
- [Swarmpit](https://swarmpit.io/)
- [Prometheus](https://prometheus.io)
- [Graphana](https://grafana.com/)
- [Postgres](https://www.postgresql.org/)

This swarm stack is fully compatible with raspberry PI as base images are also built on ARRCH64 architecture. Here is the swarmpit dashboard using 4 raspberry PI5 cluster


## 🛠️ Install Dependencies 
Apache spark and apache kyuubi need extra jars located in **app\spark\jars** and **app\kyuubi\jars** that can be downloaded by these scripts

```bash
scripts/download.sh
scripts/download.bat
```

#### Apache spark jars list
- aws-java-sdk-bundle-1.12.757.jar
- hadoop-aws-3.3.4.jar
- hadoop-cloud-storage-3.3.4.jar
- iceberg-spark-runtime-3.5_2.12-1.5.2.jar
- kyuubi-spark-connector-tpcds_2.12-1.9.1.jar
- kyuubi-spark-connector-tpch_2.12-1.9.1.jar
- postgresql-42.7.3.jar
- spark-hadoop-cloud_2.12-3.5.1.jar

### Apache kyuubi jars list
- aws-java-sdk-bundle-1.12.757.jar
- hadoop-aws-3.3.6.jar
- hadoop-cloud-storage-3.3.6.jar


## ⚡ Launching the cluster
#### Using docker compose

```Bash
$ docker compose up
$ docker compose down -v
```

#### Using docker swarm

**Warning:** Due to json incompatibility between docker compose and docker swarm specifications, you must convert some tags, here is an example using linux sed command

```Bash
docker compose config | sed '/published:/s/\"//g' | sed '/^name:/d' | sed -E 's/(cpus*[^:]+:)\s*([^"#\n]+)$/\1 "\2"/' > stack.yml
```
Once the json is modify, use this command
```Bash
$ docker stack deploy -c stack.yml STACKNAME
```

Launching this will create a ingress/mesh network, the traefik edge router will redirect http and tcp request on correct container accordingly.

#### Default opened ports

|Port|Port type|Service|
|---|---|---|
|3306|TCP|MariaDB|
|10009|TCP|Apache Kyuubi|
|7077|TCP|Spark master|
|9000|HTTP|Minio|


## 🧑🏻‍💻 Demo

#### MinIO data injection
Download the [MinIO local client](https://min.io/docs/minio/linux/reference/minio-mc.html#install-mc) according to your operating system.
Create an alias and transfert a csv file
```bash
$ mc alias set raspinio http://minios3 minio minio_minio
$ mc admin info raspinio
$ mc put measurements.txt raspinio/spark-bucket
```

#### Create a hive table
Open a SQL client like [DBeaver](https://dbeaver.io/) and create a Apache kyuubi connection using the specific driver. 

Switch and describe spark catalog
```sql
USE spark_catalog;
DESC namespace default;
```
Create a staging table
```sql
CREATE TABLE measurements_staging(
station string,
temperature double
)
COMMENT 'Temperature by station'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
STORED AS TEXTFILE;
```
Display tables list
```sql
SHOW TABLES;
```
You can now inject the csv file into a TEXTFILE hive table.
```sql
LOAD DATA INPATH 's3a://spark-bucket/measurements.txt' OVERWRITE INTO TABLE measurements_staging;
```

Convert the text file staging table into parquet table
```sql
CREATE TABLE measurements_parquet STORED AS PARQUET
AS SELECT * FROM measurements_staging;
```
Launching a heavy calculation
```sql
select station, min(temperature) , max(temperature), avg(temperature)
from measurements_parquet group by station order by station
--16sec - 1.3g
--39 sec - 13go
```

#### Launch a query using kyuubi


## 🛠️ Scaling workers   
```bash
$ docker service scale STACKNAME_sparkworker=8
```

## Test on local cluster
Check the **.env** file and search for the environment variables below.
The fastest way is to launch the swarm on a single host like your local computer.
The domain **localtest.me** is pointing on 127.0.0.1, check [documentation here](https://readme.localtest.me/)

- DATANODE1_DNS=datanode1.localtest.me
- DATANODE2_DNS=datanode2.localtest.me
- DATANODE3_DNS=datanode3.localtest.me
- KYUUBI_SPARKUI_DNS=kyuubi_ui.localtest.me
- SPARK_MASTER_DNS=sparkmaster.localtest.me
- SPARK_WORKER_DNS=sparkworker.localtest.me
- ZEPPELIN_DNS=zeppelin.localtest.me
- ZEPPELIN_SPARKUI_DNS=zeppelin_ui.localtest.me

If you have to made manual configuration, open the **.env** file and modify the  environment variables using simple DNS entries like this: 

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

Then set the corresponding swarm cluster manager IP in your **local hosts file**, e.g: 192.168.1.11:2377 as the advertise address

- 192.168.1.82 postgres
- 192.168.1.82 datanode1
- 192.168.1.82 datanode2
- 192.168.1.82 datanode3
- 192.168.1.82 kyuubi_ui
- 192.168.1.82 sparkmaster
- 192.168.1.82 sparkworker
- 192.168.1.82 zeppelin
- 192.168.1.82 swarmpit
- 192.168.1.82 couchdb
- 192.168.1.82 influxdb
- 192.168.1.82 minio
- 192.168.1.82 minios3
- 192.168.1.82 kyuubi_rest
- 192.168.1.82 grafana
- 192.168.1.82 prometheus

## 🙇 Author
#### JS
- Github: [@jsminet](https://github.com/jsminet)
        
## ➤ License
Distributed under the WTFPL License. See [WTFPL LICENSE](https://en.wikipedia.org/wiki/WTFPL) for more information.