#!/bin/bash
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
	echo "Usage: 'source install_and_run.sh'"
	exit 1
fi

echo "export MHL_CONFIG=desktop" >> ~/.profile
source ~/.profile
echo $MHL_CONFIG

echo "export KAFKA_HEAP_OPTS='-Xmx1g -Xms1g'" >> ~/.profile
source ~/.profile
echo $KAFKA_HEAP_OPTS


source /home/vagrant/mhealthlab-deployable/bootstrap.sh
source /home/vagrant/mhealthlab-deployable/mhealthlab_up_slim.sh
