#!/bin/bash
if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
	echo "Usage: 'source install_and_run.sh'"
	exit 1
fi

source /home/vagrant/mhealthlab-deployable/bootstrap.sh
source /home/vagrant/mhealthlab-deployable/bin/mhealthlab_analytics_up.sh