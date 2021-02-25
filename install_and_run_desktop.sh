#!/bin/bash
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
	echo "Usage: 'source install_and_run.sh'"
	exit 1
fi

#Set desktop config directory
echo "export MHL_CONFIG=desktop" >> ~/.profile
source ~/.profile
echo $MHL_CONFIG

#Set kafka memory limits for desktop use
echo "export KAFKA_HEAP_OPTS='-Xmx1g -Xms1g'" >> ~/.profile
source ~/.profile
echo $KAFKA_HEAP_OPTS

#Run provisioning
source /home/vagrant/mhealthlab-deployable/bootstrap.sh


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

screen -list

echo 'Please open a browser and point to localhost:8080 to explore the testbed'
