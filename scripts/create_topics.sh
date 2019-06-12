#!/bin/bash
CTR=0
DIR1=$(cat ../cluster1/terraform/hosts.yml | yq -c '.broker.hosts| keys[1]' | tr -d '"')
DIR2=$(cat ../cluster2/terraform/hosts.yml | yq -c '.broker.hosts| keys[1]' | tr -d '"')
PARTITIONS=$4
RF=$5
echo "Cluster #1 boostrap server ["$DIR1"]"
echo "Cluster #2 boostrap server ["$DIR2"]"
for ((i=$2;i<=$3;i++));
do
        TOPIC_NAME=$1"-"$i
        $KAFKA_HOME/bin/kafka-topics --create --zookeeper ${DIR1}:2181 --if-not-exists --replication-factor $RF --partitions $PARTITIONS --topic $TOPIC_NAME &
        $KAFKA_HOME/bin/kafka-topics --create --zookeeper ${DIR2}:2181 --if-not-exists --replication-factor $RF --partitions $PARTITIONS --topic $TOPIC_NAME &
        CTR=$((CTR + 1))
        if [ $CTR -gt 10 ]
        then
                sleep 20 
                CTR=0
        fi
done
