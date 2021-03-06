FROM java:8

RUN apt-get update -y && \ 
    apt-get install vim -y && \
    apt-get install openssh-server -y && \
    apt-get install rsync -y 

WORKDIR /home/hduser

RUN wget -q http://www-eu.apache.org/dist/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz && tar zxvf hadoop-2.9.0.tar.gz && rm hadoop-2.9.0.tar.gz
RUN wget -q http://www-eu.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz && tar zxvf spark-2.3.1-bin-hadoop2.7.tgz && rm spark-2.3.1-bin-hadoop2.7.tgz

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

RUN sed -i -e 's/${JAVA_HOME}/\/usr\/lib\/jvm\/java-8-openjdk-amd64/g' /home/hduser/hadoop-2.9.0/etc/hadoop/hadoop-env.sh

RUN echo "ListenAddress 0.0.0.0" > /etc/ssh/sshd_config

COPY ssh_config /etc/ssh/ssh_config

ENV HADOOP_HOME /home/hduser/hadoop-2.9.0
ENV SPARK_HOME /home/hduser/spark-2.3.1-bin-hadoop2.7

COPY mapred-site.xml  $HADOOP_HOME/etc/hadoop/
COPY yarn-site.xml    $HADOOP_HOME/hadoop/
COPY core-site.xml    $HADOOP_HOME/etc/hadoop/
COPY hdfs-site.xml    $HADOOP_HOME/etc/hadoop/
COPY log4j.properties $SPARK_HOME/conf

EXPOSE 50070 50075 50010 50020 50090 8020 9000 10020 19888 8088 8030 8031 8032 8033 8040 8042 22 4040 9000 7077 8080

ENV PATH $PATH:$SPARK_HOME/bin

WORKDIR /home/hduser/desarrollo

COPY docker-entrypoint.sh $HADOOP_HOME/etc/hadoop/
COPY hive-site.xml    $SPARK_HOME/conf/
COPY core-site.xml    $SPARK_HOME/conf/
COPY hdfs-site.xml    $SPARK_HOME/conf/
ENTRYPOINT $HADOOP_HOME/etc/hadoop/docker-entrypoint.sh
