#!/bin/bash
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
	echo "Usage: 'source install_desktop.sh'"
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

