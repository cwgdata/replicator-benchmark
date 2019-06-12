#!/bin/bash
for ((i=$2;i<=$3;i++));
do
        TOPIC_NAME=$1"-"$i
        /usr/bin/kafka-producer-perf-test --producer-props bootstrap.servers=ec2-34-214-114-167.us-west-2.compute.amazonaws.com:9092 --record-size $4 --topic $TOPIC_NAME  --num-records $5 --throughput $6 --print-metrics

done
