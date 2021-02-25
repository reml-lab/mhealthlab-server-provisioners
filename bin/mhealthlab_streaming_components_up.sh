#!/bin/bash
source ~/.profile

echo "Starting mHealthLab streaming components at ${MHL_ROOT}"

java -version

cd $MHL_ROOT

#./bin/start_kafka.sh
$MHL_ROOT/bin/start_kafka.sh

sleep 2s

#./bin/start_DCS.sh
$MHL_ROOT/bin/start_DCS.sh

sleep 2s

#./bin/start_vs.sh
$MHL_ROOT/bin/start_vs.sh

sleep 2s

screen -list