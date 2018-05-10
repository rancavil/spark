#!/bin/bash
service ssh start

if [ ! -d "/home/hduser/hadoop-2.9.0/apps" ]; then
	$HADOOP_HOME/bin/hdfs namenode -format
fi
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

bash
