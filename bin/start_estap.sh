echo "Checking Elasticsearch status"
echo $(curl -XGET localhost:9200) | grep 'mHealthLab'
  
while [ ! "$?" -eq 0 ]
do
        echo "Elasticsearch not available.  Retrying."
        sleep 2s
        echo $(curl -XGET localhost:9200) | grep 'mHealthLab'
done

echo "Elasticsearch available"
echo 'Starting elastic tap'
screen -d -m -S elastictap
sleep 1s
screen -S elastictap -p 0 -X stuff "cd ${MHL_ROOT}/apps/ElasticTap_jar; ./run.sh
"
