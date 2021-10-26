#!/bin/bash
# echo commands to the terminal output
set -ex

export DFS_NAMENODE_NAME_DIR=${DFS_NAMENODE_NAME_DIR:-/opt/namenode}
export DFS_DATANODE_DATA_DIR=${DFS_DATANODE_DATA_DIR:-/opt/datanode}

HADOOP_CMD="$1"
case "$HADOOP_CMD" in

  namenode)
  shift 1
    CMD=(hdfs namenode "$@")
    if [ ! -d "$DFS_NAMENODE_NAME_DIR" ]; then
      echo Creating $DFS_NAMENODE_NAME_DIR
      mkdir -p $DFS_NAMENODE_NAME_DIR
      hdfs namenode -format -force
    fi
    ;;

  datanode)
  shift 1
    CMD=(hdfs datanode "$@")
    if [ ! -d "$DFS_DATANODE_DATA_DIR" ]; then
      echo Creating $DFS_DATANODE_DATA_DIR
      mkdir -p $DFS_DATANODE_DATA_DIR
    fi
    ;;

  historyserver)
  shift 1
    CMD=(yarn historyserver "$@")
    ;;

  proxyserver)
  shift 1
    CMD=(yarn proxyserver "$@")
    ;;

  nodemanager)
  shift 1
    CMD=(yarn nodemanager "$@")
    ;;

  resourcemanager)
  shift 1
    CMD=(yarn resourcemanager "$@")
    ;;

  *)
    echo "Unknown command: $HADOOP_CMD" 1>&2
    exit 1
esac

# Execute the container CMD under tini for better hygiene
env
exec tini -s -- "${CMD[@]}"