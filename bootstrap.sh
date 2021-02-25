#!/bin/bash

# install java 8
sudo apt-get update
sudo apt-get install openjdk-8-jdk-headless -y
java -version

## install python3.8
sudo apt-get install python3.8 -y

# configure environment for mHL
echo "Setting environment variables..."

# alias python to python3
echo "alias python=python3" >> ~/.profile

echo "export MHL_ROOT=/home/vagrant/mhealthlab-deployable" >> ~/.profile
source ~/.profile
echo $MHL_ROOT

echo "export MHL_LIBS=${MHL_ROOT}/libs" >> ~/.profile
source ~/.profile
echo $MHL_LIBS

echo "export KAFKA_ROOT=${MHL_LIBS}/kafka" >> ~/.profile
source ~/.profile
echo $KAFKA_ROOT

echo "export ELASTIC_ROOT=${MHL_LIBS}/elasticsearch" >> ~/.profile
source ~/.profile
echo $ELASTIC_ROOT

echo "export KIBANA_ROOT=${MHL_LIBS}/kibana" >> ~/.profile
source ~/.profile
echo $KIBANA_ROOT

echo "export AIRFLOW_HOME=~/airflow" >> ~/.profile
source ~/.profile
echo $AIRFLOW_HOME

echo "export AUTOLAUNCH=/vagrant/autolaunch" >> ~/.profile
source ~/.profile
echo $AUTOLAUNCH

echo "Done"

# basic config
sudo bash -c 'echo "export *               hard    nofile          100000" >> /etc/security/limits.conf'

#Below does not run in docker. Gives error sysctl: setting key "vm.max_map_count": Read-only file system
#sudo sysctl -w vm.max_map_count=262144

# install and configure kafka inside MHL_ROOT/libs/ directory
sudo curl "https://archive.apache.org/dist/kafka/0.10.1.0/kafka_2.11-0.10.1.0.tgz" -o /home/kafka.tgz
sudo mkdir -p $MHL_ROOT/libs/kafka && cd $MHL_ROOT/libs/kafka
sudo tar -xvzf /home/kafka.tgz -C . --strip 1

sudo mkdir logs
sudo chmod -R 777 logs/

# remove kafka tar file
#rm /home/kafka.tgz

# download elasticsearch and kibana
#mkdir /vagrant/autolaunch
cd /home

# elasticsearch
sudo wget -O elasticsearch.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.1.tar.gz
sudo wget -O elasticsearch.tar.gz.sha1 https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.1.tar.gz.sha1
#sudo sha1sum -c elasticsearch.tar.gz.sha1 #TODO this is failing...

# kibana
sudo wget -O kibana.tar.gz https://artifacts.elastic.co/downloads/kibana/kibana-5.5.1-linux-x86_64.tar.gz
sudo wget -O kibana.tar.gz.sha1 https://artifacts.elastic.co/downloads/kibana/kibana-5.5.1-linux-x86_64.tar.gz.sha1

# install elasticsearch and kibana
sudo mkdir -p $ELASTIC_ROOT && cd $ELASTIC_ROOT
sudo tar -xvzf /home/elasticsearch.tar.gz -C $ELASTIC_ROOT --strip 1

sudo cp $MHL_ROOT/config_$MHL_CONFIG/elasticsearch.yml $ELASTIC_ROOT/config/
sudo cp $MHL_ROOT/config_$MHL_CONFIG/jvm.options $ELASTIC_ROOT/config/

sudo mkdir -p $KIBANA_ROOT && cd $KIBANA_ROOT
sudo tar -xvzf /home/kibana.tar.gz -C $KIBANA_ROOT --strip 1
sudo cp $MHL_ROOT/config_$MHL_CONFIG/kibana.yml $KIBANA_ROOT/config/

sudo mkdir -p $ELASTIC_ROOT/data
sudo mkdir -p $ELASTIC_ROOT/logs
sudo chmod -R 777 $ELASTIC_ROOT/data
sudo chmod -R 777 $ELASTIC_ROOT/logs

# set ownership of everything back to user
sudo chown -R vagrant:vagrant $MHL_ROOT
sudo chmod -R 777 $MHL_ROOT

# install python and components
sudo apt-get install python3.8 -y

sudo apt install python3-pip -y

# install cerebral cortex
# Leaving out lon install of CC for now
#pip3 install cerebralcortex-kernel 

# copy demo directory to synced folder
cp -r $MHL_ROOT/demos/generator /vagrant/

# install apache webserver
sudo apt update
sudo apt install apache2 -y

# configure webserver
sudo rm /var/www/html/index.html
sudo cp -r $MHL_ROOT/demos/generator/live.html /var/www/html/
sudo cp -r $MHL_ROOT/config_$MHL_CONFIG/index.html /var/www/html/
sudo cp -r $MHL_ROOT/config_$MHL_CONFIG/health.jpg /var/www/html/
sudo cp -r $MHL_ROOT/config_$MHL_CONFIG/map.png /var/www/html/
apachectl start

# install airflow
pip3 install pip==20.2.4
echo "PATH: ${PATH}"
. ~/.profile
echo "PATH: ${PATH}"
pip3 install apache-airflow  #should this be using pip3? pip is not found
pip3 install apache-airflow['cncf.kubernetes']

#Seem to neeed this export as stuff is being created in /home/vagrant/.local/bin
export PATH=/home/vagrant/.local/bin:$PATH

airflow db init

airflow users create \
	--username admin \
	--password adminpass \
	--firstname Jane \
	--lastname Smith \
	--role Admin \
	--email airflowuser@umass.edu # not a real address...
	
sudo mkdir "${AIRFLOW_HOME}/dags"
sudo chown -R vagrant:vagrant $AIRFLOW_HOME
sudo chmod -R 775 $AIRFLOW_HOME

#airflow webserver -p 8181 &
#airflow scheduler &

# install autolauncher
sudo mkdir -p "${AUTOLAUNCH}/apps"
sudo touch "${AUTOLAUNCH}/launch_commands"
sudo chown -R vagrant:vagrant $AUTOLAUNCH
sudo chmod -R 775 $AUTOLAUNCH

cd /home/
sudo git clone https://gitlab.com/erisinger/autolaunch.git
cd autolaunch
sudo chmod 777 ./launch_records/
sudo git checkout dev
sudo cp -r apps/test $AUTOLAUNCH/apps
sudo cp launch_commands $AUTOLAUNCH
sudo cp config/airflow.cfg $AIRFLOW_HOME

# start autolaunch/airflow: bin/autolaunch_standalone_up.sh or bin/autolaunch_with_airflow_up.sh

# prepare jupyter config (started in mhealthlab_up.sh)
sudo mkdir /vagrant/jupyter
sudo chown -R vagrant:vagrant /vagrant/jupyter
sudo chmod -R 777 /vagrant/jupyter

#Download large project binaries
echo "Downloading DCRS.jar"
curl "https://people.cs.umass.edu/~marlin/mhlab/DCRS.jar" -o $MHL_ROOT/apps/DCRS_jar/DCRS.jar
echo "Downloading ObelixTap.jar"
curl "https://people.cs.umass.edu/~marlin/mhlab/ObelixTap.jar" -o $MHL_ROOT/apps/ElasticTap_jar/ObelixTap.jar
echo "Downloading SCHTap.jar"
curl "https://people.cs.umass.edu/~marlin/mhlab/SCHTap.jar" -o $MHL_ROOT/apps/schtap/SCHTap.jar
echo "Downloading SDCRS.jar"
curl "https://people.cs.umass.edu/~marlin/mhlab/SDCRS.jar" -o $MHL_ROOT/apps/SDCRS_jar/SDCRS.jar
echo "Downloading VisualizationServer.jar"
curl "https://people.cs.umass.edu/~marlin/mhlab/VisualizationServer.jar" -o $MHL_ROOT/apps/VisualizationServer_jar/VisualizationServer.jar


#Start apache
sudo apachectl start

# run cc integration test
#python3 /home/vagrant/mhealthlab-deployable/demos/cc_integration/cc_integration_test.py