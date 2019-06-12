#!/bin/bash
CUR=$((`date +%s`*1000+`date +%-N`/1000000))
PRE=$((`date +%s`*1000+`date +%-N`/1000000-6300000))
echo "http://ec2-35-165-97-130.us-west-2.compute.amazonaws.com:9021/2.0/metrics/uL5p1PvNTS-RoPmAFnM7jw/broker/requests?start="$PRE"&end="$CUR"&interval=60000"
curl -s "http://ec2-35-165-97-130.us-west-2.compute.amazonaws.com:9021/2.0/metrics/uL5p1PvNTS-RoPmAFnM7jw/broker/requests?start="$PRE"&end="$CUR"&interval=60000" | jq -r '.[] | "\(.timestamp/1000|strftime("%B %d %Y %I:%M%p %Z")),\(.bytesOutPerSec/1024/1024),\(.bytesInPerSec/1024/1024)"'
