#!/bin/bash
CLUSTER1=$(cat ../cluster1/terraform/hosts.yml | yq -c '.broker.hosts| keys[1]' | tr -d '"')
CLUSTER2=$(cat ../cluster2/terraform/hosts.yml | yq -c '.broker.hosts| keys[1]' | tr -d '"')

TASKS=$1
TOPICS=$2
TOPIC_NAME_PREFIX=$3

CONFIG="
{
  \"name\": \"replicate-${TASKS}-${TOPICS}-${TOPIC_NAME_PREFIX}\",
  \"config\": {
    \"connector.class\": \"io.confluent.connect.replicator.ReplicatorSourceConnector\",
    \"topic.regex\": \"^${TOPIC_NAME_PREFIX}.*\$\",
    \"key.converter\": \"io.confluent.connect.replicator.util.ByteArrayConverter\",
    \"value.converter\": \"io.confluent.connect.replicator.util.ByteArrayConverter\",
    \"dest.kafka.bootstrap.servers\": \"${CLUSTER1}:9092\",
    \"dest.kafka.replication.factor\": 3,
    \"src.kafka.bootstrap.servers\": \"${CLUSTER2}:9092\",
    \"src.consumer.interceptor.classes\": \"io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor\",
    \"src.consumer.confluent.monitoring.interceptor.bootstrap.servers\": \"${CLUSTER2}:9092\",
    \"src.consumer.group.id\": \"rep-ben-${TASKS}-${TOPICS}-${TOPIC_NAME_PREFIX}\",
    \"src.kafka.timestamps.producer.interceptor.classes\": \"io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor\",
    \"src.kafka.timestamps.producer.confluent.monitoring.interceptor.bootstrap.servers\": \"${CLUSTER1}:9092\",
    \"offset.timestamps.commit\": \"false\",
    \"tasks.max\": \"${TASKS}\"
  }
}"
JSON_NAME=replicate-${TOPIC_NAME_PREFIX}-${TASKS}-${TOPICS}.json
echo $CONFIG > $JSON_NAME
CONNECT=$(cat ../cluster1/terraform/hosts.yml | yq -c '.["connect-distributed"].hosts | keys[1]' | tr -d '"')
curl -X POST -H "Content-Type: application/json" --data @${JSON_NAME} ${CONNECT}:8083/connectors

