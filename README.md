# docker-spark-full-stack
Apache spark demo with Hadoop, Zeppelin, Hive on mysql running on docker Swarm

Launching with docker compose
````docker compose up --remove-orphans```

Magic command to launch with docker swarm
```docker stack deploy -c <(docker-compose config) stack-name-here```