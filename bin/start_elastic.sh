
source ~/.profile

echo 'Starting elasticsearch'
screen -d -m -S es
sleep 1s
screen -S es -p 0 -X stuff "${ELASTIC_ROOT}/bin/elasticsearch
"

echo "Checking Elasticsearch status"
echo $(curl -XGET localhost:9200) | grep 'mHealthLab'
  
while [ ! "$?" -eq 0 ]
do
	echo "Elasticsearch not available.  Retrying."
	sleep 2s
	echo $(curl -XGET localhost:9200) | grep 'mHealthLab'
done

echo "Elasticsearch available"

# configure index template to correctly handle timestamps
curl -H 'Content-Type: application/json' -XPUT http://localhost:9200/_template/mhl_template -d '{"order":0,"template":"*","settings":{},"mappings":{"auto":{"properties":{"timestamp":{"format":"epoch_millis","type":"date"}}}},"aliases":{}}'

# start kibana
echo 'Starting kibana'
screen -d -m -S kb
sleep 1s
screen -S kb -p 0 -X stuff "${KIBANA_ROOT}/bin/kibana
"

echo 'Starting elastic tap'
screen -d -m -S elastictap
sleep 1s
screen -S elastictap -p 0 -X stuff "cd ${MHL_ROOT}/apps/ElasticTap_jar; ./run.sh
"

echo "Checking Kibana status"
echo $(curl -XGET localhost:5601) | grep '/app/kibana'

while [ ! "$?" -eq 0 ]
do
	echo "Kibana not available.  Retrying."
	sleep 2s
	echo $(curl -XGET localhost:5601) | grep '/app/kibana'
done

echo "Kibana available"

# import kibana dashboard
curl -XPOST 'http://localhost:5601/api/kibana/dashboards/import' -H 'Content-Type: application/json' -H "kbn-xsrf: true" -d @"${MHL_ROOT}/config/dash.json"