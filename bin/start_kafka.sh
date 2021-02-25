# start kafka cluster
#echo 'checking for stale screen sessions...'
#killall screen

echo 'starting zookeeper...'
screen -d -m -S zk
sleep 1s
screen -S zk -p 0 -X stuff "${KAFKA_ROOT}/bin/zookeeper-server-start.sh $MHL_ROOT/config_$MHL_CONFIG/zookeeper.properties
"
sleep 10s
echo 'zookeeper running'

echo 'starting kafka broker 0...'
screen -d -m -S broker-0
sleep 1s
screen -S broker-0 -p 0 -X stuff "${KAFKA_ROOT}/bin/kafka-server-start.sh $MHL_ROOT/config_$MHL_CONFIG/server-0.properties
"
sleep 2s
echo 'broker 0 running'

#echo 'starting kafka broker 1...'
#screen -d -m -S broker-1
#sleep 1s
#screen -S broker-1 -p 0 -X stuff "${KAFKA_ROOT}/bin/kafka-server-start.sh $MHL_ROOT/config/server-1.properties
#"
#sleep 2s
#echo 'broker 1 running'
#
#echo 'starting kafka broker 2...'
#screen -d -m -S broker-2
#sleep 1s
#screen -S broker-2 -p 0 -X stuff "${KAFKA_ROOT}/bin/kafka-server-start.sh $MHL_ROOT/config/server-2.properties
#"
#sleep 2s
#echo 'broker 2 running'


