#!/bin/bash
FILE=$1
CONNECT=$(cat ../cluster1/terraform/hosts.yml | yq -c '.["connect-distributed"].hosts | keys[1]' | tr -d '"')
echo $CONNECT
echo "curl -X POST -H \"Content-Type: application/json\" --data @${FILE} ${CONNECT}:8083/connectors"
curl -X POST -H "Content-Type: application/json" --data @${FILE} ${CONNECT}:8083/connectors
