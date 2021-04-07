#!/bin/bash
export CLUSTER_ID='lkc-53j8n'
export PATH=$PATH:~/ccloud
export TOPIC_NAME='demo.covid.live.data'
ccloud login
ccloud kafka cluster use $CLUSTER_ID
ccloud kafka topic create $TOPIC_NAME
export CCLOUD_BOOTSTRAP_SERVER='pkc-4nym6.us-east-1.aws.confluent.cloud:9092'
export CCLOUD_API_KEY='VWDIFBVBOU3H3ADI'
export CCLOUD_API_SECRET='WCTTj2LQ1C2fuLwCN3zPNuloAQ5SEWt+mWMqC1ts5Z4JrYAwOubRAMppbdWFU0Jt'
i=0
while true
do
	curl --location --request GET 'https://api.covid19api.com/summary' | kafkacat -b ${CCLOUD_BOOTSTRAP_SERVER} -P  -X security.protocol=SASL_SSL -X sasl.mechanisms=PLAIN \
 -X sasl.username=${CCLOUD_API_KEY} -X sasl.password=${CCLOUD_API_SECRET} \
 -X api.version.request=true -t $TOPIC_NAME
	i=$((i+1))
	echo "----->Published the COVID-19 data to the topic $TOPIC_NAME<-----"
	echo "Published $i times"
	sleep 60
done
