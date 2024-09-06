FROM nvcr.io/nvidia/deepstream:7.0-gc-triton-devel

ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Install Apache Kafka
RUN apt update -y
RUN apt install -y openjdk-8-jdk
#export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/

RUN mkdir /opt/apache/
RUN wget 'https://downloads.apache.org/kafka/3.6.2/kafka_2.13-3.6.2.tgz' -P /opt/apache/

WORKDIR /opt/apache/
RUN tar -zxf kafka_2.13-3.6.2.tgz
RUN ln -s ./kafka_2.13-3.6.2 ./kafka

ENV PATH=/opt/apache/kafka/bin${PATH:+:${PATH}}

# Install supervisord
RUN apt-get update && apt-get install -y supervisor
COPY supervisord-kafka.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

ENV CUDA_VER=12
WORKDIR /opt/nvidia/deepstream/deepstream/sources/apps
