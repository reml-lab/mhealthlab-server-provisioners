
source ~/.profile

#Make sure elastic search is running 
echo "Checking Elasticsearch status"
echo $(curl -XGET localhost:9200) | grep 'mHealthLab'
  
while [ ! "$?" -eq 0 ]
do
	echo "Elasticsearch not available.  Retrying."
	sleep 2s
	echo $(curl -XGET localhost:9200) | grep 'mHealthLab'
done

echo "Elasticsearch available"

# start kibana
echo 'Starting kibana'
screen -d -m -S kb
sleep 1s
screen -S kb -p 0 -X stuff "${KIBANA_ROOT}/bin/kibana
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
curl -XPOST 'http://localhost:5601/api/kibana/dashboards/import' -H 'Content-Type: application/json' -H "kbn-xsrf: true" -d @"${MHL_ROOT}/config_$MHL_CONFIG/dash.json"