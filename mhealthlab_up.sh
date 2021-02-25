#!/bin/bash
source ~/.profile

echo "Starting mHealthLab platform at ${MHL_ROOT}"

java -version

echo 'Destroying stale screen sessions...'
killall screen

cd $MHL_ROOT

#./bin/start_kafka.sh
$MHL_ROOT/bin/start_kafka.sh

sleep 2s

#./bin/start_elastic.sh
$MHL_ROOT/bin/start_elastic.sh

sleep 4s

#./bin/start_DCS.sh
$MHL_ROOT/bin/start_DCS.sh

sleep 2s

#./bin/start_vs.sh
$MHL_ROOT/bin/start_vs.sh

sleep 2s

# TODO move this to own script
echo 'Starting Jupyter notebook as user:'; whoami


screen -d -m -S jupyter
sleep 1s
screen -S jupyter -p 0 -X stuff "cd /vagrant/jupyter; jupyter notebook --ip=0.0.0.0 --no-browser --NotebookApp.token='' --NotebookApp.password=''
"

screen -list

echo 'Please open a browser and point to localhost:8080 to explore the testbed'