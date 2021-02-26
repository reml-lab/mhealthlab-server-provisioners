#!/bin/bash
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
	echo "Usage: 'source run_desktop.sh'"
	exit 1
fi

#Start services 
source ~/.profile
echo "Starting mHealthLab services at ${MHL_ROOT}"
echo 'Destroying stale screen sessions...'
killall screen

cd $MHL_ROOT

$MHL_ROOT/bin/start_kafka.sh

sleep 4s

$MHL_ROOT/bin/start_DCS.sh

sleep 2s

$MHL_ROOT/bin/start_vs.sh

sleep 2s

$MHL_ROOT/bin/start_SCH.sh

sleep 2s

sudo apachectl start

screen -list

echo 'Please open a browser and point to localhost:8080 to explore the testbed'
