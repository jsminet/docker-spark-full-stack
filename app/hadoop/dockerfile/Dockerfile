FROM openjdk:8-jdk-buster
LABEL maintainer="JS Minet"

ENV HADOOP_VERSION 3.2.2
ENV HADOOP_HOME /opt/hadoop-${HADOOP_VERSION}

ENV BUILD_DEPS tini
ENV PATH $PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /opt

RUN set -ex && \
  apt-get update && DEBIAN_FRONTEND=noninteractive && \
  apt-get install -y --no-install-recommends ${BUILD_DEPS} && \
  wget --progress=bar:force:noscroll -O hadoop-binary.tar.gz \
  "http://apache.mirror.iphh.net/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" && \
  tar -xvf hadoop-binary.tar.gz && \
  rm hadoop-binary.tar.gz && \
  rm -rf /opt/hadoop-${HADOOP_VERSION}/share/doc && \
  cd ${HADOOP_HOME} && \
  chmod +x /usr/local/bin/docker-entrypoint.sh && \
  rm -rf /var/lib/apt/lists/*

COPY etc/hadoop/* ${HADOOP_HOME}/etc/hadoop/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["namenode"]