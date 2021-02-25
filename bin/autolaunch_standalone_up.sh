#!/bin/bash

#echo "export AIRFLOW=1" >> ~/.profile
#source ~/.profile
#
#airflow webserver -p 8181 &
#airflow scheduler &

# https://stackoverflow.com/questions/610839/how-can-i-programmatically-create-a-new-cron-job
# https://stackoverflow.com/questions/84882/sudo-echo-something-etc-privilegedfile-doesnt-work

if [[ ! -z $AIRFLOW && $AIRFLOW -eq 1 ]]
then
	echo "* * * * * vagrant /bin/bash /home/autolaunch/autolaunch.sh -a -d ${AIRFLOW_HOME}/dags" | sudo tee -a /etc/cron.d/per_minute
	
else
	echo "* * * * * vagrant /bin/bash /home/autolaunch/autolaunch.sh" | sudo tee -a /etc/cron.d/per_minute
fi