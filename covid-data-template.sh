#!/bin/bash
export CLUSTER_ID=''
export PATH=$PATH:~/ccloud
export TOPIC_NAME=''
ccloud login
ccloud kafka cluster use $CLUSTER_ID
ccloud kafka topic create $TOPIC_NAME
export CCLOUD_BOOTSTRAP_SERVER=''
export CCLOUD_API_KEY=''
export CCLOUD_API_SECRET=''
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
