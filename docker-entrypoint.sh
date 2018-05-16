#!/bin/bash
service ssh start

if [ ! -d "/home/hduser/hadoop-2.9.0/apps" ]; then
	$HADOOP_HOME/bin/hdfs namenode -format
fi
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

if $($HADOOP_HOME/bin/hdfs dfs -test -d /warehouse/tables); then
        echo "warehouse exists"
        $HADOOP_HOME/bin/hdfs dfsadmin -safemode leave
else
        echo "creating warehouse"
        $HADOOP_HOME/bin/hdfs dfs -mkdir -p /warehouse/tables
        $HADOOP_HOME/bin/hdfs dfs -chmod g+w /warehouse/tables
fi

bash

