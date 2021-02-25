#!/bin/bash
source ~/.profile

echo "Starting mHealthLab platform at ${MHL_ROOT}"

java -version

echo 'Destroying stale screen sessions...'
killall screen

cd $MHL_ROOT

#./bin/start_kafka.sh
$MHL_ROOT/bin/start_kafka.sh

sleep 4s

#./bin/start_DCS.sh
$MHL_ROOT/bin/start_DCS.sh

sleep 2s

#./bin/start_vs.sh
$MHL_ROOT/bin/start_vs.sh

sleep 2s

screen -list

echo 'Please open a browser and point to localhost:8080 to explore the testbed'