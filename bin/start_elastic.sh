
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
